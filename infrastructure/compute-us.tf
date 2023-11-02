# This will contain the compute instances and compute related infrastructure from North Virginia
resource "aws_instance" "us_instance" {
  provider      = aws.us_provider
  ami           = data.aws_ami.us_vpn_server_image.id
  instance_type = "t2.micro"
  tags = {
    Type = "vpn_us"
  }
}

resource "aws_instance" "eu_instance" {
  provider      = aws.eu_provider
  ami           = data.aws_ami.us_vpn_server_image.id
  instance_type = "t2.micro"
  tags = {
    Type = "vpn_eu"
  }
}
