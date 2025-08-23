resource "proxmox_vm_qemu" "k3s_m1" {
  name        = "k3s-m1"
  desc        = "k3s master 1"
  agent       = 1
  vmid        = 231
  target_node = "pve"
  bios        = "seabios"
  clone       = "pkr-ubuntu-noble"
  full_clone  = true
  cores       = 4
  memory      = 7680
  sockets     = 1
  scsihw      = "virtio-scsi-pci"

  onboot = true

  define_connection_info = false

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 33
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      clone,
      full_clone,
      vmid,
      disk,
      vm_state,
    ]
  }

  # Cloud Init Settings
  ipconfig0  = "ip=192.168.33.231/24,gw=192.168.33.1"
  nameserver = "192.168.33.1"
  ciuser     = "nikk"
  sshkeys    = var.PUBLIC_SSH_KEY
}

resource "proxmox_vm_qemu" "k3s_m2" {
  name        = "k3s-m2"
  desc        = "k3s master 2"
  agent       = 1
  vmid        = 232
  target_node = "pve"
  bios        = "seabios"
  clone       = "pkr-ubuntu-noble"
  full_clone  = true
  cores       = 4
  memory      = 7680
  sockets     = 1
  scsihw      = "virtio-scsi-pci"

  onboot = true

  define_connection_info = false

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 33
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      clone,
      full_clone,
      vmid,
      disk,
      vm_state,
    ]
  }

  # Cloud Init Settings
  ipconfig0  = "ip=192.168.33.232/24,gw=192.168.33.1"
  nameserver = "192.168.33.1"
  ciuser     = "nikk"
  sshkeys    = var.PUBLIC_SSH_KEY
}

resource "proxmox_vm_qemu" "k3s_m3" {
  name        = "k3s-m3"
  desc        = "k3s master 3"
  agent       = 1
  vmid        = 233
  target_node = "pve"
  bios        = "seabios"
  clone       = "pkr-ubuntu-noble"
  full_clone  = true
  cores       = 4
  memory      = 7680
  sockets     = 1
  scsihw      = "virtio-scsi-pci"

  onboot = true

  define_connection_info = false

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 33
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      clone,
      full_clone,
      vmid,
      disk,
      vm_state,
    ]
  }

  # Cloud Init Settings
  ipconfig0  = "ip=192.168.33.233/24,gw=192.168.33.1"
  nameserver = "192.168.33.1"
  ciuser     = "nikk"
  sshkeys    = var.PUBLIC_SSH_KEY
}

resource "proxmox_vm_qemu" "k3s_w1" {
  name        = "k3s-w1"
  desc        = "k3s worker 1"
  agent       = 1
  vmid        = 234
  target_node = "pve"
  bios        = "seabios"
  clone       = "pkr-ubuntu-noble"
  full_clone  = true
  cores       = 4
  memory      = 7680
  sockets     = 1
  scsihw      = "virtio-scsi-pci"

  onboot = true

  define_connection_info = false

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 33
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      clone,
      full_clone,
      vmid,
      disk,
      vm_state,
    ]
  }

  # Cloud Init Settings
  ipconfig0  = "ip=192.168.33.234/24,gw=192.168.33.1"
  nameserver = "192.168.33.1"
  ciuser     = "nikk"
  sshkeys    = var.PUBLIC_SSH_KEY
}

resource "proxmox_vm_qemu" "k3s_w2" {
  name        = "k3s-w2"
  desc        = "k3s worker 2"
  agent       = 1
  vmid        = 235
  target_node = "pve"
  bios        = "seabios"
  clone       = "pkr-ubuntu-noble"
  full_clone  = true
  cores       = 4
  memory      = 7680
  sockets     = 1
  scsihw      = "virtio-scsi-pci"

  onboot = true

  define_connection_info = false

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 33
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      clone,
      full_clone,
      vmid,
      disk,
      vm_state,
    ]
  }

  # Cloud Init Settings
  ipconfig0  = "ip=192.168.33.235/24,gw=192.168.33.1"
  nameserver = "192.168.33.1"
  ciuser     = "nikk"
  sshkeys    = var.PUBLIC_SSH_KEY
}
