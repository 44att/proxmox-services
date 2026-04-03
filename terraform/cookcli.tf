
resource "proxmox_lxc" "cookcli" {
  target_node     = "pve2"
  hostname        = "cookcli"
  ostemplate      = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.cookcli_lxcid

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "4G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    gw     = var.gateway_ip
    ip     = var.cookcli_ip
    ip6    = "auto"
    hwaddr = var.cookcli_mac
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = data.vault_kv_secret_v2.proxmox-pwd.data["password"]
      host     = var.pve2_address
    }
    inline = [
      "pct set ${var.cookcli_lxcid} -mp0 /mnt/pve/app_config/cookcli,mp=/mnt/pve/app_config/cookcli",
      "pct reboot ${var.cookcli_lxcid}",
    ]
  }
}
