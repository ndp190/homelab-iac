resource "proxmox_vm_qemu" "cka_node1" {
  name        = "cka-node1"
  desc        = "CKA Lab Node 1"
  agent       = 1
  vmid        = 201
  target_node = "pve"
  bios        = "seabios"
  clone       = "pkr-ubuntu-noble"
  full_clone  = true
  cores       = 2
  memory      = 7680
  sockets     = 1
  scsihw      = "virtio-scsi-pci"

  onboot      = true

  define_connection_info = false

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 33
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      disk,
      vm_state,
      full_clone,
    ]
  }

  # Cloud Init Settings
  ipconfig0 = "ip=192.168.33.201/24,gw=192.168.33.1"
  nameserver = "192.168.33.1"
  ciuser = "nikk"
  sshkeys = var.PUBLIC_SSH_KEY
}

resource "proxmox_vm_qemu" "cka_node2" {
  name        = "cka-node2"
  desc        = "CKA Lab Node 2"
  agent       = 1
  vmid        = 202
  target_node = "pve"
  bios        = "seabios"
  clone       = "pkr-ubuntu-noble"
  full_clone  = true
  cores       = 2
  memory      = 7680
  sockets     = 1
  scsihw      = "virtio-scsi-pci"

  onboot      = true

  define_connection_info = false

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 33
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      disk,
      vm_state,
      full_clone,
    ]
  }

  # Cloud Init Settings
  ipconfig0 = "ip=192.168.33.202/24,gw=192.168.33.1"
  nameserver = "192.168.33.1"
  ciuser = "nikk"
  sshkeys = var.PUBLIC_SSH_KEY
}
