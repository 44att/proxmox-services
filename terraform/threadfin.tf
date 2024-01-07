resource "proxmox_lxc" "threadfin" {
  target_node     = "hades"
  hostname        = "threadfin"
  ostemplate      = "/mnt/pve/iso/template/cache/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.threadfin_lxcid
  nameserver      = var.gateway_ip_vlan_10

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "4G"
  }

  mountpoint {
    mp      = "/Threadfin-data"
    size    = "4G"
    slot    = 1
    key     = "1"
    storage = "/mnt/pve/app_data/threadfin"
    volume  = "/mnt/pve/app_data/threadfin"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    tag    = 10
    gw     = var.gateway_ip_vlan_10
    ip     = var.threadfin_ip
    ip6    = "auto"
    hwaddr = var.threadfin_mac
  }

  lifecycle {
    ignore_changes = [
      mountpoint[0].storage
    ]
  }
}
