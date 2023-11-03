# Terraform 1.5.7 with AWS provider 5.17.0 will be used
# There are 2 providers present, one for Ireland and one for USA

terraform {
  required_version = "1.5.7"
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
  alias  = "eu_provider"
  region = "eu-west-1"
}
