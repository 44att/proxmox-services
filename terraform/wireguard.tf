resource "proxmox_lxc" "wireguard" {
  target_node     = "pve2"
  hostname        = "wireguard"
  ostemplate      = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.wireguard_lxcid
  nameserver      = var.vpn_gateway_ip

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "4G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    tag    = 10
    gw     = var.vpn_gateway_ip
    ip     = var.wireguard_ip
    ip6    = "auto"
  }
}
