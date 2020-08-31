resource "aws_db_instance" "postgresql" {
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  name                 = var.db_name
  username             = var.db_username
  password             = var.db_userpass
  parameter_group_name = var.parameter_group_name
}

resource "aws_rds_cluster" "postgresql" {
  cluster_identifier      = var.cluster_identifier
  engine                  = var.cluster_engine
  database_name           = var.db_cluster_name
  master_username         = var.master_username
  master_password         = var.master_userpass
  backup_retention_period = var.period
  preferred_backup_window = var.backup_window
  engine_version          = var.cluster_engine_version
}