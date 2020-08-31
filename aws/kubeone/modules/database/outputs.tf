output "postgresql_url" {
  value = aws_db_instance.postgresql.endpoint
}

output "postgresql_cluster_url" {
  value = aws_rds_cluster.postgresql.endpoint
}
