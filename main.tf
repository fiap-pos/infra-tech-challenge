
module "mongodb" {
  source = "./modules/mongodb"
  aws_region = var.aws_region 
  atlas_org_id = var.atlas_org_id 
  atlas_project_name = var.atlas_project_name
  atlas_region = var.atlas_region
  environment = var.environment
  auth_application_tag_name = var.auth_application_tag_name 
  producao_application_tag_name = var.producao_application_tag_name
  default_tag = var.default_tag
}

module "rds" {
  source = "./modules/rds"
  aws_region = var.aws_region
  environment = var.environment
  lanchonete_application_tag_name = var.lanchonete_application_tag_name
}

module "sqs" {
  source = "./modules/sqs"
  producao_application_tag_name = var.producao_application_tag_name
}