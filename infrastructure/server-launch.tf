# # Data blocks to obtain latest Amazon Linux Image
data "aws_ami" "us_vpn_server_image" {
  provider    = aws.us_provider
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_ami" "eu_vpn_server_image" {
  provider    = aws.eu_provider
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# # Launch templates with Ansible Pull
# resource "aws_launch_template" "us_vpn_server_template" {
#   provider      = aws.us_provider
#   name          = "vpn_server_template"
#   instance_type = "t2.micro"
#   image_id      = data.aws_ami.us_vpn_server_image.id
#   user_data     = filebase64(("./user-data.sh"))
# }

# resource "aws_launch_template" "eu_vpn_server_template" {
#   provider      = aws.eu_provider
#   name          = "vpn_server_template"
#   instance_type = "t2.micro"
#   image_id      = data.aws_ami.eu_vpn_server_image.id
#   user_data     = filebase64(("./user-data.sh"))
# }
