output "server_ip" {
  description = "The public IP address of the Linode instance"
  value       = linode_instance.constellation_overwatch.ip_address
}

output "server_private_ip" {
  description = "The private IP address of the Linode instance"
  value       = linode_instance.constellation_overwatch.private_ip_address
}

output "domain_name" {
  description = "The configured domain name"
  value       = var.domain_name
}

output "ssh_connection" {
  description = "SSH connection command"
  value       = "ssh root@${linode_instance.constellation_overwatch.ip_address}"
}