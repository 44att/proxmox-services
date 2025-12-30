resource "proxmox_lxc" "samba" {
  provider        = proxmox.pve1
  target_node     = "pve1"
  hostname        = "samba"
  ostemplate      = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.samba_lxcid

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-lvm"
    size    = "4G"
  }

  mountpoint {
    mp      = "/storage"
    size    = "8G"
    slot    = 0
    key     = "0"
    storage = "/storage"
    volume  = "/storage"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    gw     = var.gateway_ip
    ip     = var.samba_ip
    ip6    = "auto"
    hwaddr = var.samba_mac
  }

  lifecycle {
    ignore_changes = [
      mountpoint[0].storage
    ]
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = var.proxmox_password
      host     = var.pve1_address
    }
    inline = [
      "grep -qxF 'lxc.idmap = u 0 100000 1005' /etc/pve/lxc/${var.samba_lxcid}.conf || echo 'lxc.idmap = u 0 100000 1005' >> /etc/pve/lxc/${var.samba_lxcid}.conf",
      "grep -qxF 'lxc.idmap = g 0 100000 1005' /etc/pve/lxc/${var.samba_lxcid}.conf || echo 'lxc.idmap = g 0 100000 1005' >> /etc/pve/lxc/${var.samba_lxcid}.conf",
      "grep -qxF 'lxc.idmap = u 1005 1005 1' /etc/pve/lxc/${var.samba_lxcid}.conf || echo 'lxc.idmap = u 1005 1005 1' >> /etc/pve/lxc/${var.samba_lxcid}.conf",
      "grep -qxF 'lxc.idmap = g 1005 1005 1' /etc/pve/lxc/${var.samba_lxcid}.conf || echo 'lxc.idmap = g 1005 1005 1' >> /etc/pve/lxc/${var.samba_lxcid}.conf",
      "grep -qxF 'lxc.idmap = u 1006 101006 64530' /etc/pve/lxc/${var.samba_lxcid}.conf || echo 'lxc.idmap = u 1006 101006 64530' >> /etc/pve/lxc/${var.samba_lxcid}.conf",
      "grep -qxF 'lxc.idmap = g 1006 101006 64530' /etc/pve/lxc/${var.samba_lxcid}.conf || echo 'lxc.idmap = g 1006 101006 64530' >> /etc/pve/lxc/${var.samba_lxcid}.conf",
      "grep -qxF 'root:1005:1' /etc/subuid || echo 'root:1005:1' >> /etc/subuid",
      "grep -qxF 'root:1005:1' /etc/subgid || echo 'root:1005:1' >> /etc/subgid",
      "chown -R 1005:1005 /storage"
    ]
  }
}
