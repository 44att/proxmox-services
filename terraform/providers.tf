// pve2 node - default
provider "proxmox" {
  pm_api_url  = var.pve2_api_url
  pm_user     = var.proxmox_user
  pm_password = data.vault_kv_secret_v2.proxmox-pwd.data["password"]
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
  pm_password = data.vault_kv_secret_v2.proxmox-pwd.data["password"]
  // Required when using self signed certs
  pm_tls_insecure = true
  pm_parallel = 2
  pm_timeout  = 600
}

# Configure the Vault provider with address and authentication
# Using token auth for simplicity - production should use AppRole or other methods
provider "vault" {
  # Vault server address - can also be set via VAULT_ADDR environment variable
  address = var.vault_address

  # Authentication token - prefer environment variable VAULT_TOKEN for security
  token   = var.vault_token

  # Skip TLS verification only for development environments
  skip_tls_verify = var.environment == "dev" ? true : false
}
