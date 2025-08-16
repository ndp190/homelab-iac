resource "proxmox_vm_qemu" "bazzite" {
  name        = "bazzite"
  desc        = "Gaming VM with NVIDIA GPU Passthrough"
  agent       = 1
  vmid        = 103
  target_node = "pve"
  bios        = "ovmf"
  machine     = "q35"
  scsihw      = "virtio-scsi-single"
  memory      = 8192
  cores       = 4
  sockets     = 1
  onboot      = true
  iso         = "local:iso/bazzite-nvidia-stable-amd64.iso"

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


  # VGA, should set to "none" when GPU passthrough is used
  vga {
    type = "qxl"
  }

  # Network Device
  network {
    model     = "virtio"
    bridge    = "vmbr0"
    tag       = 33
  }

  # PCI Passthrough
  # PCI passthrough and display settings omitted due to provider limitations

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      full_clone,
      iso,
      vmid,
      # boot,
      # define_connection_info,
      # qemu_os,
      disk,
      vga,
    ]
  }
}
