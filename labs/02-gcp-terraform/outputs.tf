output "vm_name" {
  value       = google_compute_instance.web_vm.name
  description = "Nome da VM criada"
}

output "vm_public_ip" {
  value       = google_compute_instance.web_vm.network_interface[0].access_config[0].nat_ip
  description = "IP Público para conexão SSH e testes"
}