resource "proxmox_lxc" "homepage" {
  target_node     = "hades"
  hostname        = "homepage"
  ostemplate      = "/mnt/pve/iso/template/cache/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.homepage_lxcid
  memory          = 1024
  nameserver      = var.gateway_ip

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "4G"
  }

  mountpoint {
    mp      = "/Homepage-data"
    size    = "1G"
    slot    = 0
    key     = "0"
    storage = "/mnt/pve/app_data/homepage/config"
    volume  = "/mnt/pve/app_data/homepage/config"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    gw     = var.gateway_ip
    ip     = var.homepage_ip
    ip6    = "auto"
    hwaddr = var.homepage_mac
  }

  lifecycle {
    ignore_changes = [
      mountpoint[0].storage
    ]
  }
}
