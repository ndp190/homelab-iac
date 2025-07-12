resource "proxmox_vm_qemu" "compute" {
  name        = "compute"
  desc        = "Media VM for Docker (via SSH) and transcoding"
  agent       = 1
  vmid        = 1101
  target_node = "pve"
  bios        = "seabios"
  clone       = "pkr-ubuntu-noble"
  full_clone  = true
  cores       = 16
  memory      = 16384
  sockets     = 1
  scsihw      = "virtio-scsi-pci"
  onboot      = true

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 33
  }

  disk {
    type     = "scsi"
    storage  = "hdd-vmstore"
    size     = "128G"
    iothread = 1
    slot     = 1 # Ensures this disk is attached as scsi1 (predictable device in guest, e.g., /dev/sdb)
  }

  lifecycle {
    ignore_changes = [
      disk,
      vm_state
    ]
  }

  # Cloud Init Settings
  ipconfig0 = "ip=192.168.33.102/24,gw=192.168.33.1"
  nameserver = "192.168.33.1"
  ciuser = "nikk"
  sshkeys = var.PUBLIC_SSH_KEY

  # To install Docker and ffmpeg on first boot, upload a custom user-data file to your Proxmox node (e.g., /var/lib/vz/snippets/media-user-data.yaml)
  # Then add the following attribute to this resource:
  cicustom = "user=local-lvm:snippets/media-user-data.yaml"
}

# Upload media-user-data.yaml to Proxmox snippets using Terraform
resource "null_resource" "upload_media_userdata" {
  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -i /path/to/proxmox_id_rsa ${path.module}/compute_vm_data.yaml root@<PROXMOX_HOST>:/var/lib/vz/snippets/compute_vm_data.yaml"
  }
}

# Make the VM depend on the upload
resource "proxmox_vm_qemu" "media" {
  # ... (existing config)
  depends_on = [null_resource.upload_media_userdata]
}
