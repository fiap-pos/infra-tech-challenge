

# Mongo outputs
output "atlas_cluster_connection_string" { value = module.mongodb.atlas_cluster_connection_string }
output "project_name" { value = module.mongodb.project_name }

output "auth_database_name" { value = module.mongodb.auth_database_name }
output "auth_username" { value = module.mongodb.auth_username } 
output "auth_user_password" { 
  sensitive = true
  value = module.mongodb.auth_user_password 
}

# RDS outputs
output "security_group_id" { value = module.rds.security_group_id }

output "lanchonete_db_host" { value = module.rds.lanchonete_db_host }
output "lanchonete_username" { value = module.rds.lanchonete_username }
output "lanchonete_user_password" { 
  sensitive = true
  value = module.rds.lanchonete_user_password 
}

# SQS outputs
output "producao_queue_url" { value = module.sqs.producao_queue_url }
output "producao_queue_dlq_url" { value = module.sqs.producao_queue_dlq_url }

