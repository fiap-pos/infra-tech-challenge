# Atlas Organization ID 
variable "atlas_org_id" {
  type        = string
  description = "Atlas Organization ID"
}
# Atlas Project Name
variable "atlas_project_name" {
  type        = string
  description = "Atlas project name"
}

# Application Tag name
variable "auth_application_tag_name" {
  type        = string
  description = "Application tag name"
}

# Atlas Project Environment
variable "environment" {
  type        = string
  description = "The environment to be built"
}

# Atlas Region
variable "atlas_region" {
  type        = string
  description = "Atlas region where resources will be created"
}

variable "aws_region" {
  type = string
  description = "AWS Region"
}

variable "default_tag" {
  type = string
  description = "default tag"
}