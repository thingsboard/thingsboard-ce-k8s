variable "svca_name" {
  description = "service account for k8s cluster"
  default     = "k8s-svc-account"
}

variable "project" {
  description = "project when k8s cluster will be setup"
}

variable "bucket_name" {
  description = "name of storage bucket for kops"
  default     = "k8s-kops-bucket"
}

variable "vpc_name" {
  description = "name of vpc network for kops"
  default     = "kops-network"
}