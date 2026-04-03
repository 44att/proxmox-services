resource "proxmox_lxc" "bazarr" {
  target_node     = "pve2"
  hostname        = "bazarr"
  ostemplate      = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.bazarr_lxcid
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
    ip     = var.bazarr_ip
    ip6    = "auto"
    hwaddr = var.bazarr_mac
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = data.vault_kv_secret_v2.proxmox-pwd.data["password"]
      host     = var.pve2_address
    }
    inline = [
      "pct set ${var.bazarr_lxcid} -mp0 /mnt/pve/media_root/media,mp=/mnt/media_root/media",
      "pct set ${var.bazarr_lxcid} -mp1 /mnt/pve/app_config/bazarr,mp=/Bazarr-data",
      "pct reboot ${var.bazarr_lxcid}",
    ]
  }
}
