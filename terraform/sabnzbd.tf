resource "proxmox_lxc" "sabnzbd" {
  target_node     = "pve2"
  hostname        = "sabnzbd"
  ostemplate      = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.sabnzbd_lxcid
  memory          = 2048

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "4G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    gw     = var.gateway_ip
    ip     = var.sabnzbd_ip
    hwaddr = var.sabnzbd_mac
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = data.vault_kv_secret_v2.proxmox-pwd.data["password"]
      host     = var.pve2_address
    }
    inline = [
      "pct set ${var.sabnzbd_lxcid} -mp0 /mnt/pve/media_root/usenet,mp=/mnt/media_root/usenet",
      "pct set ${var.sabnzbd_lxcid} -mp1 /mnt/pve/app_config/sabnzbd,mp=/Sabnzbd-data",
      "pct reboot ${var.sabnzbd_lxcid}",
    ]
  }
}
