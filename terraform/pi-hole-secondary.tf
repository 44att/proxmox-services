resource "proxmox_lxc" "pi-hole-secondary" {
  target_node     = "hades"
  hostname        = "pi-hole-secondary"
  ostemplate      = "/mnt/pve/iso/template/cache/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.pi-hole-secondary_lxcid
  memory          = 1024
  cores           = 2

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "4G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    gw     = var.gateway_ip
    ip     = var.pi-hole-secondary_ip
    ip6    = "auto"
    hwaddr = var.pi-hole-secondary_mac
  }
}
