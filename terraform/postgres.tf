
resource "proxmox_lxc" "postgres" {
  target_node     = "pve2"
  hostname        = "postgres"
  ostemplate      = "local:vztmpl/ubuntu-26.04-standard_26.04-1_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.postgres_lxcid
  memory          = 8192

  features {
    nesting = true
    keyctl  = true
  }

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "20G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    gw     = var.gateway_ip
    ip     = var.postgres_ip
    ip6    = "auto"
    hwaddr = var.postgres_mac
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = data.vault_kv_secret_v2.proxmox-pwd.data["password"]
      host     = var.pve2_address
    }
    inline = [
      "pct set ${var.postgres_lxcid} -mp0 /mnt/pve/app_config/postgres,mp=/mnt/app_config/postgres",
      "pct reboot ${var.postgres_lxcid}",
    ]
  }
}
