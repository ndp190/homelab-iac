variable "opnsense_password" {
  description = "Password for OPNsense root user."
  type        = string
  sensitive   = true
}

resource "proxmox_vm_qemu" "opnsense" {
  name        = "opnsense"
  vmid        = 100
  target_node = "pve"
  iso         = "local:iso/OPNsense-25.1-dvd-amd64.iso"
  cores       = 4
  memory      = 2048
  sockets     = 1
  scsihw      = "virtio-scsi-single"
  boot        = "order=ide2;scsi0"
  onboot      = true

  disk {
    size     = "20G"
    type     = "scsi"
    storage  = "local-lvm"
    format   = "qcow2"
    discard  = "on"
    iothread = true
  }
  network {
    model    = "virtio"
    bridge   = "vmbr0"
    # net0: LAN (no VLAN)
  }
  network {
    model    = "virtio"
    bridge   = "vmbr0"
    tag      = 33
    # net1: WAN (VLAN 33)
  }
  depends_on = [null_resource.build_ubuntu_noble_template]
}
