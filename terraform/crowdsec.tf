resource "proxmox_lxc" "crowdsec" {
  target_node     = "hades"
  hostname        = "crowdsec"
  ostemplate      = "/mnt/pve/iso/template/cache/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.crowdsec_lxcid
  memory          = 1024
  nameserver      = var.gateway_ip

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "4G"
  }

  mountpoint {
    mp      = "/Crowdsec-data"
    size    = "8G"
    slot    = 0
    key     = "0"
    storage = "/mnt/pve/app_data/crowdsec"
    volume  = "/mnt/pve/app_data/crowdsec"
  }

  mountpoint {
    mp      = "/var/log/traefik"
    size    = "8G"
    slot    = 1
    key     = "1"
    storage = "/mnt/pve/app_data/traefik/logs"
    volume  = "/mnt/pve/app_data/traefik/logs"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    gw     = var.gateway_ip
    ip     = var.crowdsec_ip
    ip6    = "auto"
    hwaddr = var.crowdsec_mac
  }

  lifecycle {
    ignore_changes = [
      mountpoint[0].storage,
      mountpoint[1].storage
    ]
  }
}
