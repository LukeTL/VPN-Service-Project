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
