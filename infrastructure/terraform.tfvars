# Variable value initialisatsion

## VPC
us_vpc_cidr_block = "10.0.0.0/16"
eu_vpc_cidr_block = "192.168.0.0/16"

## Subnets
us_subnet_details = [
  {
    subnet_name = "us_east_1a_private"
    subnet_cidr = "10.0.1.0/24"
    subnet_az   = "us-east-1a"
    is_public   = false
  },
  {
    subnet_name = "us_east_1a_public"
    subnet_cidr = "10.0.2.0/24"
    subnet_az   = "us-east-1a"
    is_public   = true
  },
  {
    subnet_name = "us_east_1b_private"
    subnet_cidr = "10.0.3.0/24"
    subnet_az   = "us-east-1b"
    is_public   = false
  },
  {
    subnet_name = "us_east_1b_public"
    subnet_cidr = "10.0.4.0/24"
    subnet_az   = "us-east-1b"
    is_public   = true
  }
]

eu_subnet_details = [
  {
    subnet_name = "eu_west_1a_private"
    subnet_cidr = "192.168.1.0/24"
    subnet_az   = "eu-west-1a"
    is_public   = false
  },
  {
    subnet_name = "eu_west_1a_public"
    subnet_cidr = "192.168.2.0/24"
    subnet_az   = "eu-west-1a"
    is_public   = true
  },
  {
    subnet_name = "seu_west_1b_private"
    subnet_cidr = "192.168.3.0/24"
    subnet_az   = "eu-west-1b"
    is_public   = false
  },
  {
    subnet_name = "eu_west_1b_public"
    subnet_cidr = "192.168.4.0/24"
    subnet_az   = "eu-west-1b"
    is_public   = true
  }
]
