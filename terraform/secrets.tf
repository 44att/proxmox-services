# Read database credentials from Vault KV v2 secrets engine
# The path format for KV v2 is: <mount>/data/<secret-path>
data "vault_kv_secret_v2" "cockpit-pwd" {
  mount = "kv"
  name  = "proxmox-services/cockpit-pwd"
}

data "vault_kv_secret_v2" "proxmox-pwd" {
  mount = "kv"
  name  = "proxmox-services/proxmox-pwd"
}
