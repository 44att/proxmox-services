// pve2 node - default
provider "proxmox" {
  pm_api_url  = var.pve2_api_url
  pm_user     = var.proxmox_user
  pm_password = var.proxmox_password
  // Required when using self signed certs
  pm_tls_insecure = true
  pm_parallel = 2
  pm_timeout  = 600
}

// pve1 node - specify in resource with: provider = pve1
provider "proxmox" {
  alias       = "pve1"
  pm_api_url  = var.pve1_api_url
  pm_user     = var.proxmox_user
  pm_password = var.proxmox_password
  // Required when using self signed certs
  pm_tls_insecure = true
  pm_parallel = 2
  pm_timeout  = 600
}
