# This will contain the Cloud Networking infrastructure for USA

# USA VPC
resource "aws_vpc" "us_vpc" {
  provider   = aws.us_provider
  cidr_block = var.us_vpc_cidr_block
}

# USA Public and Private Subnets
resource "aws_subnet" "us_subnets" {
  count = length(var.us_subnet_details)

  provider = aws.us_provider
  vpc_id   = aws_vpc.us_vpc.id

  cidr_block              = var.us_subnet_details[count.index].subnet_cidr
  availability_zone       = var.us_subnet_details[count.index].subnet_az
  map_public_ip_on_launch = var.us_subnet_details[count.index].is_public

  tags = {
    Name = var.us_subnet_details[count.index].subnet_name
  }
}

# Intialising USA subnets as local variables
locals {
  # All US public subnets
  us_public_subnets = [for subnet in aws_subnet.us_subnets : subnet if subnet.map_public_ip_on_launch]

  # All US private subnets
  us_private_subnets = [for subnet in aws_subnet.us_subnets : subnet if subnet.map_public_ip_on_launch == false]
}

# USA Internet Gateway
resource "aws_internet_gateway" "us_igw" {
  provider = aws.us_provider
  vpc_id   = aws_vpc.us_vpc.id
}

# Routing Table for Private USA Subnets
resource "aws_route_table" "us_private_table" {
  provider = aws.us_provider
  vpc_id   = aws_vpc.us_vpc.id

  tags = {
    Name = "us_private_table"
  }
}

# Routing Table for Public USA Subnets
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

# Associating Private Route Tables with Private Subnets
resource "aws_route_table_association" "us_private" {
  provider = aws.us_provider
  count    = length(local.us_private_subnets)

  route_table_id = aws_route_table.us_private_table.id
  subnet_id      = local.us_private_subnets[count.index].id
}

# Associating Public Route Tables with Public Subnets
resource "aws_route_table_association" "us_public" {
  provider = aws.us_provider
  count    = length(local.us_public_subnets)

  route_table_id = aws_route_table.us_public_table.id
  subnet_id      = local.us_public_subnets[count.index].id
}

resource "aws_eip" "us_east_1a_eip" {
  depends_on = [ aws_internet_gateway.us_igw ]
}

resource "aws_eip" "us_east_1b_eip" {
  depends_on = [ aws_internet_gateway.us_igw ]
}

resource "aws_nat_gateway" "us_east_1a_nat" {
  allocation_id = aws_eip.us_east_1a_eip.id
  subnet_id = local.us_public_subnets[0].id
}

resource "aws_nat_gateway" "us_east_1b_nat" {
  allocation_id = aws_eip.us_east_1b_eip.id
  subnet_id = local.us_public_subnets[1].id
}