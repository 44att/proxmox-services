resource "proxmox_lxc" "bazarr" {
  target_node     = "hades"
  hostname        = "bazarr"
  ostemplate      = "/mnt/pve/iso/template/cache/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.bazarr_lxcid
  memory          = 1024
  nameserver      = var.gateway_ip

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "4G"
  }

  mountpoint {
    mp      = "/Bazarr-data"
    size    = "8G"
    slot    = 0
    key     = "0"
    storage = "/mnt/pve/app_data/bazarr"
    volume  = "/mnt/pve/app_data/bazarr"
  }

  mountpoint {
    mp      = "/mnt/pve/media/media"
    size    = "4000G"
    slot    = 1
    key     = "1"
    storage = "/mnt/pve/media/media"
    volume  = "/mnt/pve/media/media"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    gw     = var.gateway_ip
    ip     = var.bazarr_ip
    ip6    = "auto"
    hwaddr = var.bazarr_mac
  }

  lifecycle {
    ignore_changes = [
      mountpoint[0].storage,
      mountpoint[1].storage
    ]
  }
}
