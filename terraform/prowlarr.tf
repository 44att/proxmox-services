resource "proxmox_lxc" "prowlarr" {
  target_node     = "hades"
  hostname        = "prowlarr"
  ostemplate      = "/mnt/pve/iso/template/cache/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.prowlarr_lxcid
  memory          = 1024
  nameserver      = var.gateway_ip

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "4G"
  }

  mountpoint {
    mp      = "/Prowlarr-data"
    size    = "1G"
    slot    = 0
    key     = "0"
    storage = "/mnt/pve/app_data/prowlarr/config"
    volume  = "/mnt/pve/app_data/prowlarr/config"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    gw     = var.gateway_ip
    ip     = var.prowlarr_ip
    ip6    = "auto"
    hwaddr = var.prowlarr_mac
  }

  lifecycle {
    ignore_changes = [
      mountpoint[0].storage
    ]
  }
}
