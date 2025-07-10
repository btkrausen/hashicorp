output "nomad_server_public_ips" {
  description = "Public IP address of the Consul instances"
  value       = values(module.nomad-server)[*].public_ip
}

output "nomad_client_public_ips" {
  description = "Public IP address of the Consul instances"
  value       = values(module.nomad-client)[*].public_ip
}
