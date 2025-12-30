resource "proxmox_lxc" "pi-hole-primary" {
  provider        = proxmox.pve1
  target_node     = "pve1"
  hostname        = "pi-hole-primary"
  ostemplate      = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.pi-hole_lxcid
  memory          = 1024
  cores           = 2
  nameserver      = var.gateway_ip

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-lvm"
    size    = "4G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    gw     = var.gateway_ip
    ip     = var.pi-hole-primary_ip
    ip6    = "auto"
    hwaddr = var.pi-hole-primary_mac
  }
}
