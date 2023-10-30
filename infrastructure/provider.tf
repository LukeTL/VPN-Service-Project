terraform {
  required_version = "1.4.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.17.0"
    }
  }

  backend "http" {

  }
}


provider "aws" {
  alias  = "us_provider"
  region = "us-east-1"
}

provider "aws" {
  alias  = "sg_provider"
  region = "ap-southeast-1"
}
