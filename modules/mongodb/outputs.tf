# Outputs to Display
output "atlas_cluster_connection_string" { value = mongodbatlas_advanced_cluster.atlas-cluster.connection_strings.0.standard_srv }
output "project_name" { value = mongodbatlas_project.atlas-project.name }

output "auth_database_name" { value = local.auth_database_name }
output "auth_username" { value = mongodbatlas_database_user.auth-db-user.username } 
output "auth_user_password" { 
  sensitive = true
  value = mongodbatlas_database_user.auth-db-user.password 
}

output "producao_database_name" { value = local.producao_database_name }
output "producao_username" { value = mongodbatlas_database_user.producao-db-user.username }
output "producao_user_password" { 
  sensitive = true
  value = mongodbatlas_database_user.producao-db-user.password
}