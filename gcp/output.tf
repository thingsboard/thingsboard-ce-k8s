output "storage-bucket" {
  description = "buckets name for kops"
  value = {
    endpoint = google_storage_bucket.storage-bucket.name
  }
}

output "service-account" {
  description = "service accounts name for kops"
  value = {
    endpoint = google_service_account.k8s_user.email
  }
}

output "vpc-name" {
  description = "name of vpc network"
  value = {
    endpoint = google_compute_network.kops_network.name
  }
}
