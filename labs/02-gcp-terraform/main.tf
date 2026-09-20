terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.20.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# 1. Rede VPC Customizada (Boa Prática de Segurança - Sem subredes automáticas)
resource "google_compute_network" "custom_vpc" {
  name                    = "lab-vpc"
  auto_create_subnetworks = false
}

# 2. Subrede dedicada
resource "google_compute_subnetwork" "custom_subnet" {
  name          = "lab-subnet-us-central1"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.custom_vpc.id
}

# 3. Regra de Firewall para permitir SSH e a porta da aplicação (8000)
resource "google_compute_firewall" "allow_web_ssh" {
  name    = "lab-allow-web-ssh"
  network = google_compute_network.custom_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "8000"]
  }

  # Apenas para IPs das instâncias com a tag correspondente
  target_tags   = ["web-server"]
  source_ranges = ["0.0.0.0/0"]
}

# 4. Instância de Máquina Virtual (Compute Engine - e2-micro / Always Free Tier)
# Instância de Máquina Virtual com Docker pré-instalado no Startup Script
resource "google_compute_instance" "web_vm" {
  name         = "devops-lab-vm"
  machine_type = "e2-micro"
  zone         = var.zone
  tags         = ["web-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10 # 10GB dentro da cota gratuita
    }
  }

  network_interface {
    network    = google_compute_network.custom_vpc.id
    subnetwork = google_compute_subnetwork.custom_subnet.id

    access_config {}
  }

  # Script de inicialização: Instala Docker e executa nossa API
  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker
    docker run -d -p 8000:8000 --name app --restart always python:3.11-slim sh -c "pip install fastapi uvicorn prometheus-fastapi-instrumentator && python -c 'import uvicorn, time; from fastapi import FastAPI; from prometheus_fastapi_instrumentator import Instrumentator; app = FastAPI(); Instrumentator().instrument(app).expose(app); app.add_api_route(\"/\", lambda: {\"status\": \"ok\", \"cloud\": \"gcp-compute-engine\"}); uvicorn.run(app, host=\"0.0.0.0\", port=8000)'"
  EOF
}