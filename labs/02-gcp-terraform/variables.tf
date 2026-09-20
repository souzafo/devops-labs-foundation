variable "project_id" {
  description = "ID do projeto na GCP"
  type        = string
  default     = "devops-labs-fabiano"
}

variable "region" {
  description = "Região padrão da GCP"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zona padrão para instâncias"
  type        = string
  default     = "us-central1-a"
}