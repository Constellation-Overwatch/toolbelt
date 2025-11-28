variable "linode_token" {
  description = "Linode Personal Access Token"
  type        = string
  sensitive   = true
}

variable "root_password" {
  description = "Root password for the Linode instance"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key for secure access"
  type        = string
}

variable "ssh_private_key_file" {
  description = "Path to SSH private key file for Ansible"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "domain_name" {
  description = "Domain name for the constellation-overwatch deployment"
  type        = string
  default     = ""
}

variable "domain_email" {
  description = "Email address for domain SOA record (required if using domain)"
  type        = string
  default     = ""
}

variable "github_token" {
  description = "GitHub token for pulling from GHCR"
  type        = string
  sensitive   = true
}

variable "github_username" {
  description = "GitHub username for GHCR authentication"
  type        = string
}