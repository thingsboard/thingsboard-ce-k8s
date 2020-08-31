//DATABASE STANDALONE
variable "allocated_storage" {
  default     = 20
  description = "storage size for postgresql"
}
variable "storage_type" {
  default     = "gp2"
  description = "storage type for postgresql"
}
variable "engine" {
  default     = "postgresql"
  description = "engine"
}
variable "engine_version" {
  default     = "11.6"
  description = "postgresql version"
}
variable "instance_class" {
  default     = "db.t2.micro"
  description = "instance db class"
}
variable "db_name" {
  default     = "thingsboard"
  description = "db name"
}
variable "db_username" {
  default     = "tb-admin"
  description = "db user name"
}
variable "db_userpass" {
  default     = "tb-password"
  description = "db user password"
}
variable "parameter_group_name" {
  default     = "default.postgres11"
  description = "config parameter group name"
}

// DATABASE CLUSTER
//variable "cluster_allocated_storage" {
//  default     = 20
//  description = "storage size for postgresql"
//}
//variable "cluster_storage_type" {
//  default     = "gp2"
//  description = "storage type for postgresql"
//}
variable "cluster_engine" {
  default     = "aurora-postgresql"
  description = "engine"
}
variable "cluster_engine_version" {
  default     = "11.6"
  description = "postgresql version"
}
variable "db_cluster_name" {
  default     = "thingsboard"
  description = "db name"
}
variable "master_username" {
  default     = "tb-admin"
  description = "db user name"
}
variable "master_userpass" {
  default     = "tb-password"
  description = "db user password"
}
variable "cluster_identifier" {
  default     = "thingsboard"
  description = "database cluster identifier"
}
variable "backup_window" {
  default     = "07:00-09:00"
  description = "window for backup"
}
variable "period" {
  default     = "3"
  description = "number of backups. daily backup"
}