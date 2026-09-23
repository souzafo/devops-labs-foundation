variable "project_id" {
  description = "ID do Projeto na GCP"
  type        = string
}

variable "region" {
  description = "Região principal para o cluster GKE"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "Nome do cluster GKE"
  type        = string
  default     = "gke-devops-lab"
}