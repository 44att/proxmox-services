resource "proxmox_lxc" "cockpit" {
  provider        = proxmox.pve1
  target_node     = "pve1"
  hostname        = "cockpit"
  ostemplate      = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.cockpit_lxcid
  password        = data.vault_kv_secret_v2.cockpit-pwd.data["password"]

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-lvm"
    size    = "4G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    gw     = var.gateway_ip
    ip     = var.cockpit_ip
    ip6    = "auto"
    hwaddr = var.cockpit_mac
  }

}
