terraform {
  backend "local" {
    path = "../../my-data/terraform/terraform.tfstate"
  }

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc07"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
}
