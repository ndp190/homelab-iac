terraform {
  required_version = ">= 0.13.0"
  required_providers {
    proxmox = {
      source  = "Terraform-for-Proxmox/proxmox"
      version = ">= 0.0.1"
    }
  }
}

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
