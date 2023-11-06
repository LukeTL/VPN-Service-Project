# Defining of variables needed

## VPC
variable "us_vpc_cidr_block" {
  type = string
}

variable "eu_vpc_cidr_block" {
  type = string
}

## Subnets
variable "us_subnet_details" {
  type = list(object({
    subnet_name = string
    subnet_cidr = string
    subnet_az   = string
    is_public   = bool
  }))
}

variable "eu_subnet_details" {
  type = list(object({
    subnet_name = string
    subnet_cidr = string
    subnet_az   = string
    is_public   = bool
  }))
}
