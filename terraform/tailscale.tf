resource "proxmox_lxc" "tailscale" {
  target_node     = "pve2"
  hostname        = "tailscale"
  ostemplate      = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.tailscale_lxcid

  features {
    nesting = true
    keyctl = true
  }

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "4G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    gw     = var.gateway_ip
    ip     = var.tailscale_ip
    ip6    = "auto"
    hwaddr = var.tailscale_mac
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = data.vault_kv_secret_v2.proxmox-pwd.data["password"]
      host     = var.pve2_address
    }
    inline = [
      "pct set ${var.tailscale_lxcid} -mp0 /mnt/pve/app_config/tailscale,mp=/Tailscale-data",
      "pct set ${var.tailscale_lxcid} --dev0 /dev/net/tun",
      "pct reboot ${var.tailscale_lxcid}",
    ]
  }
}
