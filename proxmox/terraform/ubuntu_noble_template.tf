# This file will trigger Packer to build the 90001-pkr-ubuntu-noble template before Terraform applies resources that depend on it.
resource "null_resource" "build_ubuntu_noble_template" {
  provisioner "local-exec" {
    command = "cd ../packer/90001-pkr-ubuntu-noble && packer build -var-file=credentials.pkrvars.hcl ."
  }
}

# Example usage: add depends_on = [null_resource.build_ubuntu_noble_template] to any resource that needs the template
