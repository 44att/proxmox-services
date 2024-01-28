resource "proxmox_lxc" "antennas" {
  target_node     = "hades"
  hostname        = "antennas"
  ostemplate      = "/mnt/pve/iso/template/cache/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.antennas_lxcid
  memory          = 4096
  cores           = 2
  nameserver      = var.gateway_ip_vlan_10

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "4G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    tag    = 10
    gw     = var.gateway_ip_vlan_10
    ip     = var.antennas_ip
    ip6    = "auto"
    hwaddr = var.antennas_mac
  }
}
