resource "proxmox_lxc" "openwrt" {
  target_node     = "pve2"
  hostname        = "openwrt"
  ostemplate      = "local:vztmpl/openwrt-24.10.5-x86-64-rootfs.tar.gz"
  unprivileged    = true
  ostype          = "unmanaged"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.openwrt_lxcid
  
  features {
    nesting = true
  }

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "4G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
  }

  network {
    name   = "eth1"
    bridge = "vmbr1"
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = data.vault_kv_secret_v2.proxmox-pwd.data["password"]
      host     = var.pve2_address
    }
    inline = [
      "grep -qxF 'lxc.cgroup2.devices.allow: c 10:200 rwm' /etc/pve/lxc/${var.openwrt_lxcid}.conf || echo 'lxc.cgroup2.devices.allow: c 10:200 rwm' >> /etc/pve/lxc/${var.openwrt_lxcid}.conf",
      "grep -qxF 'lxc.mount.entry: /dev/net dev/net none bind,create=dir' /etc/pve/lxc/${var.openwrt_lxcid}.conf || echo 'lxc.mount.entry: /dev/net dev/net none bind,create=dir' >> /etc/pve/lxc/${var.openwrt_lxcid}.conf",
      "pct exec ${var.openwrt_lxcid} uci add firewall rule",
      "pct exec ${var.openwrt_lxcid} uci set firewall.@rule[-1].name='Allow-Admin'",
      "pct exec ${var.openwrt_lxcid} uci set firewall.@rule[-1].enabled='true'",
      "pct exec ${var.openwrt_lxcid} uci set firewall.@rule[-1].src='wan'",
      "pct exec ${var.openwrt_lxcid} uci set firewall.@rule[-1].proto='tcp'",
      "pct exec ${var.openwrt_lxcid} uci set firewall.@rule[-1].dest_port='22 80 443'",
      "pct exec ${var.openwrt_lxcid} uci set firewall.@rule[-1].target='ACCEPT'",
      "pct exec ${var.openwrt_lxcid} uci commit firewall",
      "pct exec ${var.openwrt_lxcid} service firewall restart",
    ]
  }
}
