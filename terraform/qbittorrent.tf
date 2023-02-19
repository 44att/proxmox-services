resource "proxmox_lxc" "qbittorrent" {
  target_node     = "hades"
  hostname        = "qbittorrent"
  ostemplate      = "/mnt/pve/iso/template/cache/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.qbittorrent_lxcid
  memory          = 8196
  nameserver      = var.gateway_ip_vlan_10

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "4G"
  }

  mountpoint {
    mp      = "/qbittorrent-config"
    size    = "8G"
    slot    = 0
    key     = "0"
    storage = "/mnt/pve/app_data/qbittorrent/config"
    volume  = "/mnt/pve/app_data/qbittorrent/config"
  }

  mountpoint {
    mp      = "/mnt/pve/media/torrents"
    size    = "250G"
    slot    = 1
    key     = "1"
    storage = "/mnt/pve/media/torrents"
    volume  = "/mnt/pve/media/torrents"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    tag    = 10
    gw     = var.gateway_ip_vlan_10
    ip     = var.qbittorrent_ip
    ip6    = "auto"
    hwaddr = var.qbittorrent_mac
  }

  lifecycle {
    ignore_changes = [
      mountpoint[0].storage,
      mountpoint[1].storage
    ]
  }
}
