
resource "proxmox_lxc" "syncthing" {
  target_node     = "pve2"
  hostname        = "syncthing"
  ostemplate      = "local:vztmpl/ubuntu-26.04-standard_26.04-1_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.syncthing_lxcid

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
    ip     = var.syncthing_ip
    ip6    = "auto"
    hwaddr = var.syncthing_mac
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = data.vault_kv_secret_v2.proxmox-pwd.data["password"]
      host     = var.pve2_address
    }
    inline = [
      "pct set ${var.syncthing_lxcid} -mp0 /mnt/pve/documents/matt,mp=/mnt/documents/matt",
      "pct set ${var.syncthing_lxcid} -mp1 /mnt/pve/pictures/photography,mp=/mnt/pictures/photography",
      "pct set ${var.syncthing_lxcid} -mp2 /mnt/pve/app_config/syncthing,mp=/mnt/app_config/syncthing",
      "pct reboot ${var.syncthing_lxcid}",
    ]
  }
}
