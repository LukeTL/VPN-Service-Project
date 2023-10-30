resource "aws_instance" "test_instance" {
  provider      = aws.us_provider
  ami           = data.aws_ami.us_vpn_server_image.id
  instance_type = "t2.micro"
  tags = {
    Type = "vpn_us"
  }
}

resource "aws_instance" "test_instance" {
  provider      = aws.sg_provider
  ami           = data.aws_ami.sg_vpn_server_image.id
  instance_type = "t2.micro"
  tags = {
    Type = "vpn_sg"
  }
}
