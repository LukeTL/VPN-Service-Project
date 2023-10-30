resource "aws_vpc" "sg_vpc" {
  provider   = aws.sg_provider
  cidr_block = var.sg_vpc_cidr_block
}

resource "aws_subnet" "sg_subnets" {
  count = length(var.us_subnet_details)

  provider = aws.sg_provider
  vpc_id   = aws_vpc.sg_vpc.id

  cidr_block              = var.sg_subnet_details[count.index].subnet_cidr
  availability_zone       = var.sg_subnet_details[count.index].subnet_az
  map_public_ip_on_launch = var.sg_subnet_details[count.index].is_public

  tags = {
    Name = var.sg_subnet_details[count.index].subnet_name
  }
}

locals {
  sg_public_subnets  = [for subnet in aws_subnet.sg_subnets : subnet if subnet.map_public_ip_on_launch]
  sg_private_subnets = [for subnet in aws_subnet.sg_subnets : subnet if subnet.map_public_ip_on_launch == false]
}

resource "aws_internet_gateway" "sg_igw" {
  provider = aws.sg_provider
  vpc_id   = aws_vpc.sg_vpc.id
}

resource "aws_route_table" "sg_private_table" {
  provider = aws.sg_provider
  vpc_id   = aws_vpc.sg_vpc.id

  tags = {
    Name = "sg_private_table"
  }
}

resource "aws_route_table" "sg_public_table" {
  provider = aws.sg_provider
  vpc_id   = aws_vpc.sg_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sg_igw.id
  }

  tags = {
    Name = "sg_public_table"
  }
}

resource "aws_route_table_association" "sg_private" {
  provider = aws.sg_provider
  count    = length(local.sg_private_subnets)

  route_table_id = aws_route_table.sg_private_table.id
  subnet_id      = local.sg_private_subnets[count.index].id
}

resource "aws_route_table_association" "sg_public" {
  provider = aws.sg_provider
  count    = length(local.sg_public_subnets)

  route_table_id = aws_route_table.sg_public_table.id
  subnet_id      = local.sg_public_subnets[count.index].id
}