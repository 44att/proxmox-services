resource "proxmox_lxc" "firefly" {
  target_node     = "hades"
  hostname        = "firefly"
  ostemplate      = "/mnt/pve/iso/template/cache/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.firefly_lxcid
  memory          = 4096
  cores           = 2
  nameserver      = var.gateway_ip

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "4G"
  }

  mountpoint {
    mp      = "/Firefly-data"
    size    = "1G"
    slot    = 0
    key     = "0"
    storage = "/mnt/pve/app_data/firefly"
    volume  = "/mnt/pve/app_data/firefly"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    gw     = var.gateway_ip
    ip     = var.firefly_ip
    ip6    = "auto"
    hwaddr = var.firefly_mac
  }

  lifecycle {
    ignore_changes = [
      mountpoint[0].storage
    ]
  }
}
