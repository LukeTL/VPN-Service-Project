resource "aws_instance" "test_instance" {
  provider      = aws.us_provider
  instance_type = "t2.micro"
  tags = {
    Type = "vpn"
  }
}
