# This will contain the compute instances and compute related infrastructure from North Virginia
# resource "aws_instance" "us_east_1a_bastion" {
#   provider      = aws.us_provider
#   subnet_id = aws_subnet.us_subnets
#   ami           = data.aws_ami.us_vpn_server_image.id
#   instance_type = "t2.micro"
#   tags = {
#     Type = "vpn_us"
#   }
# }
