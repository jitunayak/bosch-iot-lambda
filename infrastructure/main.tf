terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


provider "aws" {
  region                  = var.region
  profile                 = var.aws_profile
  shared_credentials_file = var.shared_credentials_file
  default_tags {
    tags = var.tags
  }
}

