resource "proxmox_vm_qemu" "github_runner" {
  name        = "github-runner"
  desc        = "GitHub Runner VM"
  agent       = 1
  vmid        = 101
  target_node = "pve"
  bios        = "seabios" # default=ovmf
  clone       = "pkr-ubuntu-noble" # Name of the template VM
  full_clone  = true
  cores       = 2
  memory      = 4096
  sockets     = 1
  scsihw      = "virtio-scsi-pci"

  onboot      = true # Start VM on boot
  define_connection_info = false

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 33 # vnet 33
  }

  lifecycle {
    ignore_changes = [
      disk,
      vm_state
    ]
  }

  # Cloud Init Settings 
  ipconfig0 = "ip=192.168.33.101/24,gw=192.168.33.1"
  nameserver = "192.168.33.1"
  ciuser = "nikk"
  sshkeys = var.PUBLIC_SSH_KEY

  depends_on = [null_resource.build_ubuntu_noble_template]
}
