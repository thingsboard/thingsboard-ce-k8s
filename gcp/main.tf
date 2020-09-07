resource "google_compute_network" "kops_network" {
  name = var.vpc_name
  project = var.project
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "kops-firewall-out" {
  name    = "kops-firewall-out"
  network = google_compute_network.kops_network.name
  project = var.project

  allow {
    protocol = "tcp"
    ports    = ["80", "6443", "22", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "kops-firewall-int" {
  name    = "kops-firewall-int"
  network = google_compute_network.kops_network.name
  project = var.project
  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  source_ranges = ["10.128.0.0/9"]
}

resource "google_storage_bucket" "storage-bucket" {
  name          = var.bucket_name
  location      = "EU"
  force_destroy = true
  project = var.project
  bucket_policy_only = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_service_account" "k8s_user" {
  account_id   = var.svca_name
  display_name = "Logging User"
  project = var.project
}

resource "google_project_iam_binding" "compute-admin" {
  project = var.project
  role    = "roles/compute.admin"
  members = [
    "serviceAccount:${google_service_account.k8s_user.email}"
  ]
}

resource "google_project_iam_binding" "iam-serviceAccountUser" {
  project = var.project
  role    = "roles/iam.serviceAccountUser"
  members = [
    "serviceAccount:${google_service_account.k8s_user.email}"
  ]
}

resource "google_project_iam_binding" "viewer" {
  project = var.project
  role    = "roles/viewer"
  members = [
    "serviceAccount:${google_service_account.k8s_user.email}"
  ]
}

resource "google_project_iam_binding" "object-admin" {
  project = var.project
  role    = "roles/storage.objectAdmin"
  members = [
    "serviceAccount:${google_service_account.k8s_user.email}"
  ]
}