# This will contain the Cloud Networking infrastructure for USA

# USA VPC
resource "aws_vpc" "us_vpc" {
  provider   = aws.us_provider
  cidr_block = var.us_vpc_cidr_block
}

# USA Public and Private Subnets"
# Iterating through a variable containing a list of objects to generate subnets
resource "aws_subnet" "us_subnets" {
  provider = aws.us_provider
  count    = length(var.us_subnet_details)
  vpc_id   = aws_vpc.us_vpc.id

  cidr_block              = var.us_subnet_details[count.index].subnet_cidr
  availability_zone       = var.us_subnet_details[count.index].subnet_az
  map_public_ip_on_launch = var.us_subnet_details[count.index].is_public

  tags = {
    Name = var.us_subnet_details[count.index].subnet_name
  }
}

# Intialising USA subnets as local variables
# Public & Private Subnets as a list, each individual subnet can be found in a map
locals {
  us_public_subnets  = [for subnet in aws_subnet.us_subnets : subnet if subnet.map_public_ip_on_launch]
  us_private_subnets = [for subnet in aws_subnet.us_subnets : subnet if subnet.map_public_ip_on_launch == false]

  us_subnets = {
    us_east_1a_private = aws_subnet.us_subnets[0],
    us_east_1a_public  = aws_subnet.us_subnets[1],
    us_east_1b_private = aws_subnet.us_subnets[2],
    us_east_1b_public  = aws_subnet.us_subnets[3]
  }
}

# USA Internet Gateway
# IGW is region-scoped, public subnets will share same gateway
resource "aws_internet_gateway" "us_igw" {
  provider = aws.us_provider
  vpc_id   = aws_vpc.us_vpc.id
}

# Routing Table for Public USA Subnets
# Routing all outbound traffic in public subnets to IGW
resource "aws_route_table" "us_public_table" {
  provider = aws.us_provider
  vpc_id   = aws_vpc.us_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.us_igw.id
  }

  tags = {
    Name = "us_public_table"
  }
}

# Associating the same Public Route Table to both Public Subnets
resource "aws_route_table_association" "us_public" {
  provider = aws.us_provider
  count    = length(local.us_public_subnets)

  route_table_id = aws_route_table.us_public_table.id
  subnet_id      = local.us_public_subnets[count.index].id
}

# Creating 2 EIPs for 2 NAT Gateways
# EIPS depend on IGW
resource "aws_eip" "us_eips" {
  provider   = aws.us_provider
  count      = length(local.us_private_subnets)
  depends_on = [aws_internet_gateway.us_igw]
}

# Creating a NAT Gateway in each of the 2 Public subnets for the 2 Private subnets
# Set name of NAT Gateway based on AZ of Public Subnet
resource "aws_nat_gateway" "us_nats" {
  provider      = aws.us_provider
  count         = length(local.us_private_subnets)
  allocation_id = aws_eip.us_eips[count.index].id
  subnet_id     = local.us_public_subnets[count.index].id

  tags = {
    "Name" = "${local.us_public_subnets[count.index].availability_zone}-nat"
  }
}

# 2 Routing Tables for each Private Subnets to route to their respective NAT Gateways
resource "aws_route_table" "us_private_table" {
  provider = aws.us_provider
  count    = length(local.us_private_subnets)
  vpc_id   = aws_vpc.us_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.us_nats[count.index].id
  }
  tags = {
    Name = "${local.us_public_subnets[count.index].availability_zone}-private_table"
  }
}

# Associating the Private Route Tables with their respective Private Subnets
resource "aws_route_table_association" "us_private" {
  provider = aws.us_provider
  count    = length(local.us_private_subnets)

  route_table_id = aws_route_table.us_private_table[count.index].id
  subnet_id      = local.us_private_subnets[count.index].id
}