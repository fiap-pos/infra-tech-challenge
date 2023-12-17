#Configure backend
terraform {
  backend "s3" {
    bucket = "vwnunes-tech-challenge-61"
    key    = "infra-challenge/challenge.tfstate"
    region = "us-east-1"
  }
}

locals {
  username = "lanchonete"
  database_name = "lanchonetedb"
}

# Create a Database Password
resource "random_password" "db-user-password" {
  length = 16
  special = true
  override_special = "_%"
}

#create a security group for RDS Database Instance
resource "aws_security_group" "rds_sg" {
  name = "rds_sg"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create RDS Database Instance
resource "aws_db_instance" "lanchonete_db_rds" {
    engine = "mysql"
    engine_version = "5.7.44"
    allocated_storage = 10
    instance_class = "db.t3.micro"
    storage_type = "gp2"
    identifier = local.database_name
    db_name = local.database_name
    username = local.username
    password = random_password.db-user-password.result
    vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
    publicly_accessible = true
    skip_final_snapshot = true
    depends_on = [ aws_security_group.rds_sg ]
}

# Stores variables into AWS ssm
resource "aws_ssm_parameter" "mysql_rds_host" {
  name        = "/${var.application_tag_name}/${var.environment}/DB_HOST"
  description = "Database Host"
  type        = "String"
  value       = "${aws_db_instance.lanchonete_db_rds.endpoint}/${local.database_name}"
  depends_on = [ aws_db_instance.lanchonete_db_rds ]
}

resource "aws_ssm_parameter" "mysql_rds_username" {
  name        = "/${var.application_tag_name}/${var.environment}/DB_USERNAME"
  description = "Database Username"
  type        = "String"
  value       = "${local.username}"
  depends_on = [ aws_db_instance.lanchonete_db_rds ]
}

resource "aws_ssm_parameter" "mysql_rds_password" {
  name        = "/${var.application_tag_name}/${var.environment}/DB_PASSWORD"
  description = "Database Password"
  type        = "SecureString"
  value       = random_password.db-user-password.result
  depends_on = [ aws_db_instance.lanchonete_db_rds, random_password.db-user-password ]
}

# Outputs to Display
output "db_host" { value = "${aws_db_instance.lanchonete_db_rds.endpoint}/${local.database_name}" }
output "security_group_id" { value = aws_security_group.rds_sg.id }
output "username" { value = local.username } 
output "user_password" {  
  sensitive = true
  value = random_password.db-user-password.result 
}
