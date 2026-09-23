terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Habilitar APIs necessárias na GCP
resource "google_project_service" "container_api" {
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

# Cluster GKE Enxuto (Preemptible/Spot para economia)
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = "${var.region}-a"

  # Desabilitar a proteção de exclusão para permitir o destroy em laboratórios
  deletion_protection = false

  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
    spot         = true

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  depends_on = [google_project_service.container_api]
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "Nome do Cluster GKE criado"
}

output "gke_connect_command" {
  value       = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --zone ${google_container_cluster.primary.location} --project ${var.project_id}"
  description = "Comando para autenticar o kubectl no cluster GKE"
}