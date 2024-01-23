

locals {
  lanchonete_username = "lanchonete"
  lanchonete_database_name = "lanchonetedb"
  pagamentos_username = "pagamentos"
  pagamentos_database_name = "pagamentosdb"
  mysql_version = "5.7.44"
  mysql_instance_class = "db.t3.micro"
}


#create a security group for RDS Database Instances
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


# --- Lanchoente RDS Database Instance ---

# Create Lanchoente a Database Password
resource "random_password" "lanchonete-db-user-password" {
  length = 16
  special = true
  override_special = "_%"
}

# Create Lanchonete RDS Database Instance
resource "aws_db_instance" "lanchonete_db_rds" {
    engine = "mysql"
    engine_version = local.mysql_version
    allocated_storage = 10
    instance_class = local.mysql_instance_class
    storage_type = "gp2"
    identifier = local.lanchonete_database_name
    db_name = local.lanchonete_database_name
    username = local.lanchonete_username
    password = random_password.lanchonete-db-user-password.result
    vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
    publicly_accessible = true
    skip_final_snapshot = true
    depends_on = [ aws_security_group.rds_sg ]
}

# Stores Lanchonete variables into AWS ssm
resource "aws_ssm_parameter" "lanchonete_mysql_rds_host" {
  name        = "/${var.lanchonete_application_tag_name}/${var.environment}/DB_HOST"
  description = "Database Host"
  type        = "String"
  value       = "${aws_db_instance.lanchonete_db_rds.endpoint}/${local.lanchonete_database_name}"
  depends_on = [ aws_db_instance.lanchonete_db_rds ]
}

resource "aws_ssm_parameter" "lanchonete_mysql_rds_username" {
  name        = "/${var.lanchonete_application_tag_name}/${var.environment}/DB_USERNAME"
  description = "Database Username"
  type        = "String"
  value       = "${local.lanchonete_username}"
  depends_on = [ aws_db_instance.lanchonete_db_rds ]
}

resource "aws_ssm_parameter" "lanchonete_mysql_rds_password" {
  name        = "/${var.lanchonete_application_tag_name}/${var.environment}/DB_PASSWORD"
  description = "Database Password"
  type        = "SecureString"
  value       = random_password.lanchonete-db-user-password.result
  depends_on = [ aws_db_instance.lanchonete_db_rds, random_password.lanchonete-db-user-password ]
}


# --- Pagamentos RDS Database Instance ---

# Create Pagamentos a Database Password
resource "random_password" "pagamentos-db-user-password" {
  length = 16
  special = true
  override_special = "_%"
}

# Create Pagamentos RDS Database Instance
resource "aws_db_instance" "pagamentos_db_rds" {
    engine = "mysql"
    engine_version = local.mysql_version
    allocated_storage = 10
    instance_class = local.mysql_instance_class
    storage_type = "gp2"
    identifier = local.pagamentos_database_name
    db_name = local.pagamentos_database_name
    username = local.pagamentos_username
    password = random_password.pagamentos-db-user-password.result
    vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
    publicly_accessible = true
    skip_final_snapshot = true
    depends_on = [ aws_security_group.rds_sg ]
}

# Stores Pagamentos variables into AWS ssm

resource "aws_ssm_parameter" "pagamentos_mysql_rds_host" {
  name        = "/${var.pagamentos_application_tag_name}/${var.environment}/DB_HOST"
  description = "Database Host"
  type        = "String"
  value       = "${aws_db_instance.pagamentos_db_rds.endpoint}/${local.pagamentos_database_name}"
  depends_on = [ aws_db_instance.pagamentos_db_rds ]
}

resource "aws_ssm_parameter" "pagamentos_mysql_rds_username" {
  name        = "/${var.pagamentos_application_tag_name}/${var.environment}/DB_USERNAME"
  description = "Database Username"
  type        = "String"
  value       = "${local.pagamentos_username}"
  depends_on = [ aws_db_instance.pagamentos_db_rds ]
}

resource "aws_ssm_parameter" "pagamentos_mysql_rds_password" {
  name        = "/${var.pagamentos_application_tag_name}/${var.environment}/DB_PASSWORD"
  description = "Database Password"
  type        = "SecureString"
  value       = random_password.pagamentos-db-user-password.result
  depends_on = [ aws_db_instance.pagamentos_db_rds, random_password.pagamentos-db-user-password ]
}
