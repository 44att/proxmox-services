
resource "proxmox_lxc" "starbase80" {
  target_node     = "pve2"
  hostname        = "starbase80"
  ostemplate      = "local:vztmpl/ubuntu-26.04-standard_26.04-1_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.starbase80_lxcid

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
    ip     = var.starbase80_ip
    ip6    = "auto"
    hwaddr = var.starbase80_mac
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = data.vault_kv_secret_v2.proxmox-pwd.data["password"]
      host     = var.pve2_address
    }
    inline = [
      "pct set ${var.starbase80_lxcid} -mp0 /mnt/pve/app_config/starbase80,mp=/mnt/app_config/starbase80",
      "pct reboot ${var.starbase80_lxcid}",
    ]
  }
}
