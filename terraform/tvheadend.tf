resource "proxmox_lxc" "tvheadend" {
  target_node     = "hades"
  hostname        = "tvheadend"
  ostemplate      = "/mnt/pve/iso/template/cache/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.tvheadend_lxcid
  memory          = 4096
  cores           = 2
  nameserver      = var.gateway_ip_vlan_10

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "4G"
  }

  mountpoint {
    mp      = "/Tvheadend-data"
    size    = "4G"
    slot    = 0
    key     = "0"
    storage = "/mnt/pve/app_data/tvheadend"
    volume  = "/mnt/pve/app_data/tvheadend"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    tag    = 10
    gw     = var.gateway_ip_vlan_10
    ip     = var.tvheadend_ip
    ip6    = "auto"
    hwaddr = var.tvheadend_mac
  }

  lifecycle {
    ignore_changes = [
      mountpoint[0].storage
    ]
  }
}