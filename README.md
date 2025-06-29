# This repository contains the infrastructure as code (IaC) for Nikk's homelab

Reproducible homelab setup

## TODO

- [x] add github actions

## Prerequisites

- Already setup proxmox node
    - Has one node named `pve` (default setting)
    - Generate API token for terraform IaC (no privilege separation)
- Download LTS version 24.04 [ubuntu image](https://cloud-images.ubuntu.com/)
    - Upload it to proxmox `local (pve)` storage
    - Rename to `ubuntu-24.04-live-server-amd64.iso`
- Download opnsense [amd image](https://opnsense.org/download/)
    - Upload it to proxmox `local (pve)` storage
    - Rename to `OPNsense-25.1-dvd-amd64.iso`

## Initial Run

After building the Proxmox image template with Packer, you can run Terraform to provision your infrastructure. On the initial run, Terraform will automatically trigger Packer to build the `90001-pkr-ubuntu-noble` template if it does not exist, using a `null_resource` with a `local-exec` provisioner.

### Steps

1. Initial IaC run should be done from node within the proxmox network, this is a one time setup.
2. Fill in `credentials.pkr.hcl` based on example `credentials.pkr.hcl.example` file
3. Update`passwd` field in  `http/user-data` to follow password set in `credentials.pkr.hcl`. This password should be hashed using the SHA-512 algorithm.
4. Ensure you have filled in `terraform/terraform.tfvars` with the required variables (see `terraform.tfvars.example`).
5. From the project root, initialize and apply Terraform:

```bash
cd proxmox/terraform-init
terraform init
terraform plan
terraform apply
```

- The first `terraform apply` will:
  - Trigger Packer to build the Ubuntu Noble template (if not already built)
  - Provision the VMs and resources as defined in the Terraform files

> **Note:** The Packer build is triggered by a `null_resource` in `ubuntu_noble_template.tf`. If you want to skip the Packer build (e.g., if the template already exists), you can taint or remove the `null_resource.build_ubuntu_noble_template` as needed.

6. In proxmox ui, enter vm 100 (opnsense) and start the installation (follow this [tutorial](https://www.youtube.com/watch?v=XXx7NDgDaRU) for a visual guide):
    - Login with `root` and `opnsense`
    - Assign interfaces (option 1)
        - `WAN` to `vtnet0`
        - `LAN` to `vtnet1`
        - leave default for other options
    - Signout (option 0)
    - Login with `installer` and `opnsense`
        - default keymap
        - ufs installation > da0 disk
        - after installation, enter your prefer opnsense root password
        - complete install and reboot
    - Spin up a vm, set its connection VLAN to 33, then access opnsense initial setup wizard at `https://192.168.1.1`
        - Configure LAN IP Address: 192.168.33.1
        - Rest of the options can be left as default > save and apply changes
        - Turn off and on network interface
        - Re-enter opnsense web interface at `https://192.168.33.1`
        - Go to System > Firmware > Updates to update opnsense to the latest version
7. Install tailscale on opnsense:
    - From proxmox web interface, go to the opnsense VM (100) login and enter Shell
    - `opnsense-code ports` to update the ports tree
    - `cd /usr/ports/security/tailscale`
    - `make install` to install tailscale
    - `service tailscaled enable` to enable the tailscale service
    - `service tailscaled start` to start the tailscale daemon
    - `tailscale up` to authenticate and connect to your tailscale network
    - Go to a proxmox VM on the same vnet network to access tailscale admin console `https://192.168.33.1`
        - Go to Interfaces > Assignments and add a new interface for Tailscale (the option should already be there)
        - [Optional] Rename the interface from `OPT1` to `TAILSCALE` for clarity
    - Go back to proxmox opnsense VM and enter Shell
    - `tailscale up --advertise-routes=192.168.33.0/24,<proxmox-ip>/32` to advertise the LAN network over Tailscale, and to advertise the Proxmox host IP over Tailscale (for direct access to the Proxmox web interface & terraform remote run)
    - Go to tailscale.com and approve the advertised routes
8. Setup github runner - follow the [GitHub Actions Runner documentation](https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners) to add the runner to your GitHub repository

## Skipping or Marking the Packer Build as Done

If you have already built the Packer template and want Terraform to treat the `null_resource.build_ubuntu_noble_template` as already done (so it does not run again):

```bash
terraform import null_resource.build_ubuntu_noble_template $(uuidgen)
```
- This will mark the resource as done without running the provisioner.
- You can use any unique string as the resource ID for a null_resource (e.g., output of `uuidgen`).

> **Note:** If you want to force the Packer build to run again, use `terraform taint null_resource.build_ubuntu_noble_template` and then `terraform apply`.

## Packer: Manual Build & Debugging

While it is recommended to let Terraform trigger the Packer build automatically (see the section above), you can also run Packer manually for debugging or development purposes.

### Manual Packer Build Steps

1. Fill in `credentials.pkr.hcl` based on the example file `credentials.pkr.hcl.example`.
2. Update the `passwd` field in `http/user-data` to match the password set in `credentials.pkr.hcl` (hashed with SHA-512).
3. Run the following commands from the project root:

```bash
cd proxmox/packer/90001-pkr-ubuntu-noble
packer init .
packer validate -var-file=credentials.pkrvars.hcl .
packer build -var-file=credentials.pkrvars.hcl .
```

- This will build the `90001-pkr-ubuntu-noble` Proxmox template independently of Terraform.
- Use this approach if you want to debug or iterate on the Packer template without running a full Terraform apply.

> **Note:** For most workflows, it is more advisable to let Terraform manage the Packer build automatically to ensure dependencies are handled correctly.

# Ref

- https://github.com/ChristianLempa/homelab/blob/main/proxmox/terraform

