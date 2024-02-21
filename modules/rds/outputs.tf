
# Outputs to Display
output "security_group_id" { value = aws_security_group.rds_sg.id }

output "lanchonete_db_host" { value = "${aws_db_instance.lanchonete_db_rds.endpoint}/${local.lanchonete_database_name}" }
output "lanchonete_username" { value = local.lanchonete_username } 
output "lanchonete_user_password" {  
  sensitive = true
  value = random_password.lanchonete-db-user-password.result 
}

output "pagamentos_db_host" { value = "${aws_db_instance.pagamentos_db_rds.endpoint}/${local.pagamentos_database_name}" }
output "pagamentos_username" { value = local.pagamentos_username }
output "pagamentos_user_password" { 
  sensitive = true
  value = random_password.pagamentos-db-user-password.result 
}