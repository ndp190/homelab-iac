# This repository contains the infrastructure as code (IaC) for Nikk's homelab

Reproducible homelab setup

## Prerequisites

- Already setup proxmox node
    - Has one node named `pve` (default setting)
    - Generate API token for terraform IaC (no privilege separation)
- Download LTS version 24.04 [ubuntu image](https://cloud-images.ubuntu.com/)
    - Upload it to proxmox `local (pve)` storage
    - Rename to `ubuntu-24.04-live-server-amd64.iso`

## Initial run

- Initial IaC run should be done from node within the proxmox network, this is a one time setup.

- Fill in credentials.pkr.hcl based on example credentials.pkr.hcl.example file

- Run:

```bash
# packer to build proxmox image template
cd /proxmox/packer
packer init ./90001-pkr-ubuntu-noble
packer validate -var-file=./90001-pkr-ubuntu-noble/credentials.pkrvars.hcl ./90001-pkr-ubuntu-noble
packer build -var-file=./90001-pkr-ubuntu-noble/credentials.pkrvars.hcl ./90001-pkr-ubuntu-noble
# terraform -chdir=proxmox/terraform init
```

## Subsequent runs

- [ ] add github actions

# Ref

- https://github.com/ChristianLempa/homelab/blob/main/proxmox/terraform

