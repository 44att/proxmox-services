resource "proxmox_lxc" "nzbget" {
  target_node     = "pve2"
  hostname        = "nzbget"
  ostemplate      = "local:vztmpl/ubuntu-26.04-standard_26.04-1_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.nzbget_lxcid
  memory          = 2048

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
    ip     = var.nzbget_ip
    hwaddr = var.nzbget_mac
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = data.vault_kv_secret_v2.proxmox-pwd.data["password"]
      host     = var.pve2_address
    }
    inline = [
      "pct set ${var.nzbget_lxcid} -mp0 /mnt/pve/media_root/usenet,mp=/mnt/media_root/usenet",
      "pct set ${var.nzbget_lxcid} -mp1 /mnt/pve/media_root/aurral,mp=/mnt/media_root/aurral",
      "pct set ${var.nzbget_lxcid} -mp2 /mnt/pve/app_config/nzbget,mp=/mnt/app_config/nzbget",
      "pct reboot ${var.nzbget_lxcid}",
    ]
  }
}
