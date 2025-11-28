terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 2.0"
    }
  }
  required_version = ">= 1.0"
}

provider "linode" {
  token = var.linode_token
}

resource "linode_instance" "constellation_overwatch" {
  label             = "constellation-overwatch-prod"
  image             = "linode/debian12"
  region            = "us-central"
  type              = "g6-standard-2"
  root_pass         = var.root_password
  authorized_keys   = [var.ssh_public_key]
  private_ip        = true
  tags              = ["constellation", "overwatch", "production"]
}


resource "linode_domain" "constellation_domain" {
  count       = var.domain_name != "" ? 1 : 0
  domain      = var.domain_name
  type        = "master"
  description = "Domain for constellation-overwatch"
  soa_email   = var.domain_email != "" ? var.domain_email : "admin@${var.domain_name}"
}

resource "linode_domain_record" "constellation_a_record" {
  count       = var.domain_name != "" ? 1 : 0
  domain_id   = linode_domain.constellation_domain[0].id
  name        = ""
  record_type = "A"
  target      = linode_instance.constellation_overwatch.ip_address
  ttl_sec     = 300
}

resource "linode_domain_record" "constellation_www_record" {
  count       = var.domain_name != "" ? 1 : 0
  domain_id   = linode_domain.constellation_domain[0].id
  name        = "www"
  record_type = "A"
  target      = linode_instance.constellation_overwatch.ip_address
  ttl_sec     = 300
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    server_ip = linode_instance.constellation_overwatch.ip_address  # Public IP address
    ssh_private_key_file = var.ssh_private_key_file
    github_username = var.github_username
    github_token = var.github_token
    domain_name = var.domain_name
    domain_email = var.domain_email
  })
  filename = "${path.module}/../ansible/inventories/production"
}