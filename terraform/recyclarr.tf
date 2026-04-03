resource "proxmox_lxc" "recyclarr" {
  target_node     = "pve2"
  hostname        = "recyclarr"
  ostemplate      = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.recyclarr_lxcid

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "4G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    gw     = var.gateway_ip
    ip     = var.recyclarr_ip
    ip6    = "auto"
    hwaddr = var.recyclarr_mac
  }
}
