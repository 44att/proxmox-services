resource "proxmox_lxc" "beets" {
  target_node     = "pve2"
  hostname        = "beets"
  ostemplate      = "local:vztmpl/ubuntu-26.04-standard_26.04-1_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.beets_lxcid
  memory          = 8192
  cores           = 4

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
    gw     = var.gateway_ip
    ip     = var.beets_ip
    ip6    = "auto"
    hwaddr = var.beets_mac
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = data.vault_kv_secret_v2.proxmox-pwd.data["password"]
      host     = var.pve2_address
    }
    inline = [
      "pct set ${var.beets_lxcid} -mp0 /mnt/pve/media_root/media/music,mp=/mnt/media_root/media/music",
      "pct set ${var.beets_lxcid} -mp1 /mnt/pve/media_root/lidarr,mp=/mnt/media_root/lidarr",
      "pct set ${var.beets_lxcid} -mp2 /mnt/pve/media_root/aurral,mp=/mnt/media_root/aurral",
      "pct set ${var.beets_lxcid} -mp3 /mnt/pve/app_config/beets,mp=/mnt/app_config/beets",
      "pct reboot ${var.beets_lxcid}",
    ]
  }
}
