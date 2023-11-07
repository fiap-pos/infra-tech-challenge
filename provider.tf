terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 0.13"
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      application = var.application_tag_name
    }
  }
}
  