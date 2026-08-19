
resource "proxmox_lxc" "vaultwarden" {
  target_node     = "pve2"
  hostname        = "vaultwarden"
  ostemplate      = "local:vztmpl/ubuntu-26.04-standard_26.04-1_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.vaultwarden_lxcid

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
    ip     = var.vaultwarden_ip
    ip6    = "auto"
    hwaddr = var.vaultwarden_mac
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = data.vault_kv_secret_v2.proxmox-pwd.data["password"]
      host     = var.pve2_address
    }
    inline = [
      "pct set ${var.vaultwarden_lxcid} -mp0 /mnt/pve/app_config/vaultwarden,mp=/mnt/app_config/vaultwarden",
      "pct reboot ${var.vaultwarden_lxcid}",
    ]
  }
}
