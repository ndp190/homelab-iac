variable "PUBLIC_SSH_KEY" {
  description = "Public SSH key to be injected into the CKA lab VMs"
  type        = string
}
variable "SV3_URL" {
  description = "Proxmox API URL"
  type        = string
}

variable "SV3_TOKEN_ID" {
  description = "Proxmox API Token ID"
  type        = string
}

variable "SV3_TOKEN_SECRET" {
  description = "Proxmox API Token Secret"
  type        = string
  sensitive   = true
}