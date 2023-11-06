# This will contain the compute instances and compute related infrastructure from Ireland
resource "aws_instance" "eu_instance" {
  provider      = aws.eu_provider
  ami           = data.aws_ami.eu_vpn_server_image.id
  instance_type = "t2.micro"
  tags = {
    Type = "vpn_eu"
  }
}