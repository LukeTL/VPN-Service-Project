resource "aws_instance" "test_instance" {
  provider      = aws.us_provider
  ami           = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
  tags = {
    Type = "vpn"
  }
}
