resource "proxmox_lxc" "radarr" {
  target_node     = "pve2"
  hostname        = "radarr"
  ostemplate      = "local:vztmpl/ubuntu-26.04-standard_26.04-1_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.radarr_lxcid
  memory          = 1024

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
    ip     = var.radarr_ip
    ip6    = "auto"
    hwaddr = var.radarr_mac
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = data.vault_kv_secret_v2.proxmox-pwd.data["password"]
      host     = var.pve2_address
    }
    inline = [
      "pct set ${var.radarr_lxcid} -mp0 /mnt/pve/media_root,mp=/mnt/media_root",
      "pct set ${var.radarr_lxcid} -mp1 /mnt/pve/app_config/radarr,mp=/mnt/app_config/radarr",
      "pct reboot ${var.radarr_lxcid}",
    ]
  }
}
