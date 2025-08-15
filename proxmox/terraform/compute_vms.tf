resource "proxmox_vm_qemu" "compute" {
  name        = "compute"
  desc        = "Media VM for Docker (via SSH) and transcoding"
  agent       = 1
  vmid        = 102
  target_node = "pve"
  bios        = "seabios"
  # clone       = "pkr-ubuntu-noble"
  # full_clone  = true
  cores       = 16
  memory      = 16384
  sockets     = 1
  scsihw      = "virtio-scsi-pci"
  onboot      = true
  iso         = "local:iso/archlinux-2025.08.01-x86_64.iso"
  boot        = "order=scsi0;ide2"

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

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 33
  }

  lifecycle {
    ignore_changes = [
      disk,
      vm_state
    ]
  }

  # Cloud Init Settings
  # ipconfig0 = "ip=192.168.33.102/24,gw=192.168.33.1"
  # nameserver = "192.168.33.1"
  # ciuser = "nikk"
  # sshkeys = var.PUBLIC_SSH_KEY

  # To install Docker and ffmpeg on first boot, upload a custom compute_vm_data file to your Proxmox node (e.g., scp ./compute_vm_data.yaml root@<PROXMOX_HOST>:/mnt/hdd-vmstore/snippets/compute_vm_data.yaml)
  # Then add the following attribute to this resource:
  # cicustom = "user=hdd-vmstore:snippets/compute_vm_data.yaml"
  # this override ssh keys and user data, hence commenting it out
}
