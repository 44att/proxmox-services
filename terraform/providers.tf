// hades node - default
provider "proxmox" {
  pm_api_url  = var.hades_api_url
  pm_user     = var.proxmox_user
  pm_password = var.proxmox_password
  // Required when using self signed certs
  pm_tls_insecure = true
  pm_parallel = 2
  pm_timeout  = 600
}

// apollo node - specify in resource with: provider = apollo
provider "proxmox" {
  alias       = "apollo"
  pm_api_url  = var.apollo_api_url
  pm_user     = var.proxmox_user
  pm_password = var.proxmox_password
  // Required when using self signed certs
  pm_tls_insecure = true
  pm_parallel = 2
  pm_timeout  = 600
}
