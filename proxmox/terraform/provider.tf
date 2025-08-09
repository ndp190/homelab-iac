terraform {
  required_version = ">= 0.13.0"
  required_providers {
    proxmox = {
      source  = "Terraform-for-Proxmox/proxmox"
      version = ">= 0.0.1"
    }
  }
  backend "s3" {
    bucket                      = "homelab-tfstate"
    key                         = "proxmox01/terraform.tfstate"
    endpoint                    = "https://eec01328bb19274e2e1ce370196d47b5.r2.cloudflarestorage.com/homelab-tfstate"
    region                      = "auto"
    skip_credentials_validation = true
    skip_region_validation      = true
  }
}

# All variables are stored in 1Password, look for "proxmox01/sv3.nikk" note and ssh keys

provider "proxmox" {
  pm_api_url          = var.SV3_URL
  pm_api_token_id     = var.SV3_TOKEN_ID
  pm_api_token_secret = var.SV3_TOKEN_SECRET
  pm_tls_insecure     = true
}
