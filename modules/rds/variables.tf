# Application Tag Name 
variable "lanchonete_application_tag_name" {
  type        = string
  description = "Application Tag Name"
}

variable "pagamentos_application_tag_name" {
  type        = string
  description = "Pagamentos application tag name"
}

variable "aws_region" {
  type = string
  description = "AWS Region"
}

variable "environment" {
  type = string
  description = "environment"
}