# resource "aws_vpc" "us_vpc" {
#   provider   = aws.us_provider
#   cidr_block = var.us_vpc_cidr_block
# }

# resource "aws_subnet" "us_subnets" {
#   count = length(var.us_subnet_details)

#   provider = aws.us_provider
#   vpc_id   = aws_vpc.us_vpc.id

#   cidr_block              = var.us_subnet_details[count.index].subnet_cidr
#   availability_zone       = var.us_subnet_details[count.index].subnet_az
#   map_public_ip_on_launch = var.us_subnet_details[count.index].is_public

#   tags = {
#     Name = var.us_subnet_details[count.index].subnet_name
#   }
# }

# locals {
#   # All US public subnets
#   us_public_subnets = [for subnet in aws_subnet.us_subnets : subnet if subnet.map_public_ip_on_launch]

#   # All US private subnets
#   us_private_subnets = [for subnet in aws_subnet.us_subnets : subnet if subnet.map_public_ip_on_launch == false]
# }

# resource "aws_internet_gateway" "us_igw" {
#   provider = aws.us_provider
#   vpc_id   = aws_vpc.us_vpc.id
# }

# resource "aws_route_table" "us_private_table" {
#   provider = aws.us_provider
#   vpc_id   = aws_vpc.us_vpc.id

#   tags = {
#     Name = "us_private_table"
#   }
# }

# resource "aws_route_table" "us_public_table" {
#   provider = aws.us_provider
#   vpc_id   = aws_vpc.us_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.us_igw.id
#   }

#   tags = {
#     Name = "us_public_table"
#   }
# }

# resource "aws_route_table_association" "us_private" {
#   provider = aws.us_provider
#   count    = length(local.us_private_subnets)

#   route_table_id = aws_route_table.us_private_table.id
#   subnet_id      = local.us_private_subnets[count.index].id
# }

# resource "aws_route_table_association" "us_public" {
#   provider = aws.us_provider
#   count    = length(local.us_public_subnets)

#   route_table_id = aws_route_table.us_public_table.id
#   subnet_id      = local.us_public_subnets[count.index].id
# }
