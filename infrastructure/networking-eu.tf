# resource "aws_vpc" "eu_vpc" {
#   provider   = aws.eu_provider
#   cidr_block = var.eu_vpc_cidr_block
# }

# resource "aws_subnet" "eu_subnets" {
#   count = length(var.us_subnet_details)

#   provider = aws.eu_provider
#   vpc_id   = aws_vpc.eu_vpc.id

#   cidr_block              = var.eu_subnet_details[count.index].subnet_cidr
#   availability_zone       = var.eu_subnet_details[count.index].subnet_az
#   map_public_ip_on_launch = var.eu_subnet_details[count.index].is_public

#   tags = {
#     Name = var.eu_subnet_details[count.index].subnet_name
#   }
# }

# locals {
#   eu_public_subnets  = [for subnet in aws_subnet.eu_subnets : subnet if subnet.map_public_ip_on_launch]
#   eu_private_subnets = [for subnet in aws_subnet.eu_subnets : subnet if subnet.map_public_ip_on_launch == false]
# }

# resource "aws_internet_gateway" "eu_igw" {
#   provider = aws.eu_provider
#   vpc_id   = aws_vpc.eu_vpc.id
# }

# resource "aws_route_table" "eu_private_table" {
#   provider = aws.eu_provider
#   vpc_id   = aws_vpc.eu_vpc.id

#   tags = {
#     Name = "eu_private_table"
#   }
# }

# resource "aws_route_table" "eu_public_table" {
#   provider = aws.eu_provider
#   vpc_id   = aws_vpc.eu_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.eu_igw.id
#   }

#   tags = {
#     Name = "eu_public_table"
#   }
# }

# resource "aws_route_table_association" "eu_private" {
#   provider = aws.eu_provider
#   count    = length(local.eu_private_subnets)

#   route_table_id = aws_route_table.eu_private_table.id
#   subnet_id      = local.eu_private_subnets[count.index].id
# }

# resource "aws_route_table_association" "eu_public" {
#   provider = aws.eu_provider
#   count    = length(local.eu_public_subnets)

#   route_table_id = aws_route_table.eu_public_table.id
#   subnet_id      = local.eu_public_subnets[count.index].id
# }
