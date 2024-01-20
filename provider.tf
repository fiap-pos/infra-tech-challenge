terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
    }
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
      environment = var.environment
      application = var.default_tag
    }
  }
}

#Configure backend
terraform {
  backend "s3" {
    bucket = "vwnunes-tech-challenge-61"
    key    = "infra-challenge/challenge.tfstate"
    region = "us-east-1"
  }
}
  