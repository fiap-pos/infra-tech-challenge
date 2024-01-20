locals {
  cluster_instance_size_name = "M0"
  cloud_provider = "AWS"
  ip_address = "0.0.0.0/0"

  auth_database_name = "techchallengeauth"
  auth_database_username = "techchallengeauth"

  producao_database_name = "techchallengeproducao"
  producao_database_username = "techchallengeproducao"
}

# Create a Project
resource "mongodbatlas_project" "atlas-project" {
  org_id = var.atlas_org_id
  name = var.atlas_project_name
}

# Create Auth Database User
resource "mongodbatlas_database_user" "auth-db-user" {
  username = local.auth_database_username
  password = random_password.auth-db-user-password.result
  project_id = mongodbatlas_project.atlas-project.id
  auth_database_name = "admin"
  roles {
    role_name     = "readWrite"
    database_name = local.auth_database_name
  }
}

# Create Producao Database User
resource "mongodbatlas_database_user" "producao-db-user" {
  username = local.producao_database_username
  password = random_password.producao-db-user-password.result
  project_id = mongodbatlas_project.atlas-project.id
  auth_database_name = "admin"
  roles {
    role_name     = "readWrite"
    database_name = local.producao_database_name
  }
}

# Create Auth Database Password
resource "random_password" "auth-db-user-password" {
  length = 16
  special = false
}

# Create Producao Database Password 
resource "random_password" "producao-db-user-password" {
  length = 16
  special = false
}

# Create Database IP Access List
resource "mongodbatlas_project_ip_access_list" "ip" {
  project_id = mongodbatlas_project.atlas-project.id
  cidr_block = local.ip_address
}

# Create an Atlas Advanced Cluster 
resource "mongodbatlas_advanced_cluster" "atlas-cluster" {
  project_id = mongodbatlas_project.atlas-project.id
  name = "${var.environment}-cluster"
  cluster_type = "REPLICASET"
  backup_enabled = false
  replication_specs {
    region_configs {
      electable_specs {
        instance_size = local.cluster_instance_size_name
      }
      priority              = 7
      provider_name         = "TENANT"
      backing_provider_name = local.cloud_provider
      region_name           = var.atlas_region
    }
  }
  tags {
    key   = "environment"
    value = var.environment
  }
  tags {
    key   = "application"
    value = var.default_tag
  }
}

# Stores variables into AWS ssm
resource "aws_ssm_parameter" "auth_mongodb_database_url" {
  name        = "/${var.auth_application_tag_name}/${var.environment}/MONGODB_URI"
  description = "Auth Mongo DB Password"
  type        = "SecureString"
  value       = "mongodb+srv://${local.auth_database_username}:${mongodbatlas_database_user.auth-db-user.password }@${replace(mongodbatlas_advanced_cluster.atlas-cluster.connection_strings.0.standard_srv, "mongodb+srv://", "")}"

  depends_on = [ 
    random_password.auth-db-user-password,
    mongodbatlas_advanced_cluster.atlas-cluster
  ]
}

# Stores variables into AWS ssm
resource "aws_ssm_parameter" "auth_mongodb_database_name" {
  name        = "/${var.auth_application_tag_name}/${var.environment}/MONGODB_DATABASE"
  description = "Database name"
  type        = "String"
  value       = local.auth_database_name
  depends_on = [ random_password.auth-db-user-password ]
}

# Store new AUTH Secret into AWS ssm
resource "aws_ssm_parameter" "auth_secret" {
  name        = "/${var.auth_application_tag_name}/${var.environment}/AUTH_SECRET"
  description = "Auth secret"
  type        = "SecureString"
  value       = uuid()
}

# Stores variables into AWS ssm
resource "aws_ssm_parameter" "producao_mongodb_database_url" {
  name        = "/${var.producao_application_tag_name}/${var.environment}/MONGODB_URI"
  description = "Producao Mongo DB Password"
  type        = "SecureString"
  value       = "mongodb+srv://${local.producao_database_username}:${mongodbatlas_database_user.producao-db-user.password }@${replace(mongodbatlas_advanced_cluster.atlas-cluster.connection_strings.0.standard_srv, "mongodb+srv://", "")}"

  depends_on = [ 
    random_password.producao-db-user-password,
    mongodbatlas_advanced_cluster.atlas-cluster
  ]
}

# Stores variables into AWS ssm
resource "aws_ssm_parameter" "producao_mongodb_database_name" {
  name        = "/${var.producao_application_tag_name}/${var.environment}/MONGODB_DATABASE"
  description = "Database name"
  type        = "String"
  value       = local.producao_database_name
  depends_on = [ random_password.producao-db-user-password ]
}