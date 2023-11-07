# This will contain the Cloud Networking infrastructure for Ireland

# Ireland VPC
resource "aws_vpc" "eu_vpc" {
  provider   = aws.eu_provider
  cidr_block = var.eu_vpc_cidr_block
}

# Ireland Public and Private Subnets
# Iterating through a variable containing a list of objects to generate subnets
resource "aws_subnet" "eu_subnets" {
  provider = aws.eu_provider
  count    = length(var.eu_subnet_details)
  vpc_id   = aws_vpc.eu_vpc.id

  cidr_block              = var.eu_subnet_details[count.index].subnet_cidr
  availability_zone       = var.eu_subnet_details[count.index].subnet_az
  map_public_ip_on_launch = var.eu_subnet_details[count.index].is_public

  tags = {
    Name = var.eu_subnet_details[count.index].subnet_name
  }
}

# Intialising Ireland subnets as local variables
locals {
  eu_public_subnets  = [for subnet in aws_subnet.eu_subnets : subnet if subnet.map_public_ip_on_launch]
  eu_private_subnets = [for subnet in aws_subnet.eu_subnets : subnet if subnet.map_public_ip_on_launch == false]

  eu_subnets = {
    eu_west_1a_private = aws_subnet.eu_subnets[0],
    eu_west_1a_public  = aws_subnet.eu_subnets[1],
    eu_west_1b_private = aws_subnet.eu_subnets[2],
    eu_west_1b_public  = aws_subnet.eu_subnets[3]
  }
}

# Ireland Internet Gateway
# IGW is region-scoped, public subnets will share same gateway
resource "aws_internet_gateway" "eu_igw" {
  provider = aws.eu_provider
  vpc_id   = aws_vpc.eu_vpc.id
}

# Routing Table for Public Ireland Subnets
# Routing all outbound traffic in public subnets to IGW
resource "aws_route_table" "eu_public_table" {
  provider = aws.eu_provider
  vpc_id   = aws_vpc.eu_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eu_igw.id
  }

  tags = {
    Name = "eu_public_table"
  }
}

# Associating the same Public Route Table to both Public Subnets
resource "aws_route_table_association" "eu_public" {
  provider = aws.eu_provider
  count    = length(local.eu_public_subnets)

  route_table_id = aws_route_table.eu_public_table.id
  subnet_id      = local.eu_public_subnets[count.index].id
}

resource "aws_eip" "eu_eips" {
  provider   = aws.eu_provider
  count      = length(local.eu_private_subnets)
  depends_on = [aws_internet_gateway.eu_igw]
}

resource "aws_nat_gateway" "eu_nats" {
  provider      = aws.eu_provider
  count         = length(local.eu_private_subnets)
  allocation_id = aws_eip.eu_eips[count.index].id
  subnet_id     = local.eu_public_subnets[count.index].id

  tags = {
    "Name" = "${local.eu_public_subnets[count.index].availability_zone}-nat"
  }
}

# 2 Routing Tables for each Private Subnets to route to their respective NAT Gateways
resource "aws_route_table" "eu_private_table" {
  provider = aws.eu_provider
  count    = length(local.eu_private_subnets)
  vpc_id   = aws_vpc.eu_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eu_nats[count.index].id
  }
  tags = {
    Name = "${local.eu_public_subnets[count.index].availability_zone}-private_table"
  }
}

# Associating the Private Route Tables with their respective Private Subnets
resource "aws_route_table_association" "eu_private" {
  provider = aws.eu_provider
  count    = length(local.eu_private_subnets)

  route_table_id = aws_route_table.eu_private_table[count.index].id
  subnet_id      = local.eu_private_subnets[count.index].id
}