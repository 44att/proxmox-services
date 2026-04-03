resource "proxmox_lxc" "sonarr" {
  target_node     = "pve2"
  hostname        = "sonarr"
  ostemplate      = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.sonarr_lxcid
  memory          = 1024

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "4G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    gw     = var.gateway_ip
    ip     = var.sonarr_ip
    ip6    = "auto"
    hwaddr = var.sonarr_mac
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = data.vault_kv_secret_v2.proxmox-pwd.data["password"]
      host     = var.pve2_address
    }
    inline = [
      "pct set ${var.sonarr_lxcid} -mp0 /mnt/pve/media_root,mp=/mnt/media_root",
      "pct set ${var.sonarr_lxcid} -mp1 /mnt/pve/app_config/sonarr,mp=/Sonarr-data",
      "pct reboot ${var.sonarr_lxcid}",
    ]
  }
}
