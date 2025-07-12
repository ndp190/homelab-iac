resource "proxmox_vm_qemu" "bazzite" {
  name        = "bazzite"
  desc        = "Gaming VM with NVIDIA GPU Passthrough"
  agent       = 1
  vmid        = 201
  target_node = "pve"
  bios        = "ovmf"
  machine     = "q35"
  scsihw      = "virtio-scsi-single"
  memory      = 8192
  cores       = 4
  sockets     = 1
  onboot      = true

  # Main Disk
  disk {
    type        = "scsi"
    storage     = "local-lvm"
    size        = "64G"
    iothread    = 1
  }

  # Second Data Disk
  disk {
    type     = "scsi"
    storage  = "hdd-vmstore"
    size     = "128G"
    iothread = 1
  }

  # Installation ISO
  disk {
    type    = "ide"
    storage = "local"
    file    = "iso/bazzite-nvidia-stable-amd64.iso"
    media   = "cdrom"
    size    = "8G"
  }

  # VGA, should set to "none" when GPU passthrough is used
  vga {
    type = "qxl"
  }

  # Network Device
  network {
    model   = "virtio"
    bridge  = "vmbr0"
    tag     = 33
  }

  # PCI Passthrough
  # PCI passthrough and display settings omitted due to provider limitations

  lifecycle {
    ignore_changes = [
      disk,
      vm_state
    ]
  }
}
