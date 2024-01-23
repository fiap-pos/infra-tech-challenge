# ---- AWS Variables ----
variable "aws_region" {
  type = string
  description = "AWS Region"
  default = "us-east-1"
}

# ---- Atlas Variables ----

# Atlas Organization ID 
variable "atlas_org_id" {
  type        = string
  description = "Atlas Organization ID"
}
# Atlas Project Name
variable "atlas_project_name" {
  type        = string
  description = "Atlas project name"
  default     = "Fiap Tech Challenge"
}

# Atlas Region
variable "atlas_region" {
  type        = string
  description = "Atlas region where resources will be created"
  default     = "US_EAST_1"
}

# ---- Common variables ----
variable "environment" {
  type = string
  description = "environment"
  default = "dev"
}

variable "default_tag" {
  type = string
  description = "default tag"
  default = "tech-challenge"
}

# ---- Lanchonete Application Variables ----

# Application Tag Name 
variable "lanchonete_application_tag_name" {
  type        = string
  description = "Lanchonete application tag Name"
  default = "tech-challenge-lanchonete"
}

# ---- Auth Application Variables ----  

# Application Tag name
variable "auth_application_tag_name" {
  type        = string
  description = "Auth application tag name"
  default     = "tech-challenge-auth"
}

# ---- Producao Application Variables ----
variable "producao_application_tag_name" {
  type        = string
  description = "Produção application tag name"
  default     = "tech-challenge-producao"
  
}

# ---- Pagamentos Application Variables ----
variable "pagamentos_application_tag_name" {
  type        = string
  description = "Pagamentos application tag name"
  default     = "tech-challenge-pagamentos"
}
