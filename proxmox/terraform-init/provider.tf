terraform {
  required_version = ">= 0.13.0"
  required_providers {
    proxmox = {
      source  = "Terraform-for-Proxmox/proxmox"
      version = ">= 0.0.1"
    }
  }
}

# All variables are stored in 1Password, look for "proxmox01/sv3.nikk" note and ssh keys

# https://192.168.128.250:8006/api2/json
variable "SV3_URL" {
  type = string
}

variable "SV3_TOKEN_ID" {
  type = string
}

variable "SV3_TOKEN_SECRET" {
  type      = string
  sensitive = true
}

provider "proxmox" {
  pm_api_url          = var.SV3_URL
  pm_api_token_id     = var.SV3_TOKEN_ID
  pm_api_token_secret = var.SV3_TOKEN_SECRET
  pm_tls_insecure     = true
}

variable "PUBLIC_SSH_KEY" {
  type        = string
  sensitive   = true
}
