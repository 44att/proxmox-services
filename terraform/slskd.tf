
resource "proxmox_lxc" "slskd" {
  target_node     = "pve2"
  hostname        = "slskd"
  ostemplate      = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.slskd_lxcid

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "4G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    gw     = var.gateway_ip
    ip     = var.slskd_ip
    ip6    = "auto"
    hwaddr = var.slskd_mac
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = data.vault_kv_secret_v2.proxmox-pwd.data["password"]
      host     = var.pve2_address
    }
    inline = [
      "pct set ${var.slskd_lxcid} -mp0 /mnt/pve/media_root/media/music,mp=/mnt/media_root/media/music",
      "pct set ${var.slskd_lxcid} -mp1 /mnt/pve/media_root/soulseek,mp=/mnt/media_root/soulseek",
      "pct set ${var.slskd_lxcid} -mp2 /mnt/pve/app_config/slskd,mp=/mnt/app_config/slskd",
      "pct reboot ${var.slskd_lxcid}",
    ]
  }
}
