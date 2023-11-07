# Application Tag Name 
variable "application_tag_name" {
  type        = string
  description = "Application Tag Name"
  default = "lanchonete_db"
}

variable "aws_region" {
  type = string
  description = "AWS Region"
  default = "us-east-1"
}

variable "environment" {
  type = string
  description = "environment"
  default = "dev"
}