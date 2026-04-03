resource "proxmox_lxc" "network" {
  provider        = proxmox.pve1
  target_node     = "pve1"
  hostname        = "network"
  ostemplate      = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.network_lxcid
  nameserver      = var.gateway_ip

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-lvm"
    size    = "4G"
  }

  mountpoint {
    mp      = "/duckdns"
    size    = "8G"
    slot    = 0
    key     = "0"
    storage = "/tank/apps/duckdns/config"
    volume  = "/tank/apps/duckdns/config"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    gw     = var.gateway_ip
    ip     = var.network_ip
    ip6    = "auto"
    hwaddr = var.network_mac
  }

  lifecycle {
    ignore_changes = [
      mountpoint[0].storage
    ]
  }
}
