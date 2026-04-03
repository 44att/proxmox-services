resource "proxmox_lxc" "plex" {
  target_node     = "pve2"
  hostname        = "plex"
  ostemplate      = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.plex_lxcid
  memory          = 8192
  cores           = 2

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "80G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    gw     = var.gateway_ip
    ip     = var.plex_ip
    ip6    = "auto"
    hwaddr = var.plex_mac
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = data.vault_kv_secret_v2.proxmox-pwd.data["password"]
      host     = var.pve2_address
    }
    inline = [
      "grep -qxF 'lxc.cgroup2.devices.allow: c 195:* rwm' /etc/pve/lxc/${var.plex_lxcid}.conf || echo 'lxc.cgroup2.devices.allow: c 195:* rwm' >> /etc/pve/lxc/${var.plex_lxcid}.conf",
      "grep -qxF 'lxc.cgroup2.devices.allow: c 234:* rwm' /etc/pve/lxc/${var.plex_lxcid}.conf || echo 'lxc.cgroup2.devices.allow: c 234:* rwm' >> /etc/pve/lxc/${var.plex_lxcid}.conf",
      "grep -qxF 'lxc.cgroup2.devices.allow: c 237:* rwm' /etc/pve/lxc/${var.plex_lxcid}.conf || echo 'lxc.cgroup2.devices.allow: c 237:* rwm' >> /etc/pve/lxc/${var.plex_lxcid}.conf",
      "grep -qxF 'lxc.mount.entry: /dev/nvidia0 dev/nvidia0 none bind,optional,create=file' /etc/pve/lxc/${var.plex_lxcid}.conf || echo 'lxc.mount.entry: /dev/nvidia0 dev/nvidia0 none bind,optional,create=file' >> /etc/pve/lxc/${var.plex_lxcid}.conf",
      "grep -qxF 'lxc.mount.entry: /dev/nvidiactl dev/nvidiactl none bind,optional,create=file' /etc/pve/lxc/${var.plex_lxcid}.conf || echo 'lxc.mount.entry: /dev/nvidiactl dev/nvidiactl none bind,optional,create=file' >> /etc/pve/lxc/${var.plex_lxcid}.conf",
      "grep -qxF 'lxc.mount.entry: /dev/nvidia-uvm dev/nvidia-uvm none bind,optional,create=file' /etc/pve/lxc/${var.plex_lxcid}.conf || echo 'lxc.mount.entry: /dev/nvidia-uvm dev/nvidia-uvm none bind,optional,create=file' >> /etc/pve/lxc/${var.plex_lxcid}.conf",
      "grep -qxF 'lxc.mount.entry: /dev/nvidia-modeset dev/nvidia-modeset none bind,optional,create=file' /etc/pve/lxc/${var.plex_lxcid}.conf || echo 'lxc.mount.entry: /dev/nvidia-modeset dev/nvidia-modeset none bind,optional,create=file' >> /etc/pve/lxc/${var.plex_lxcid}.conf",
      "grep -qxF 'lxc.mount.entry: /dev/nvidia-uvm-tools dev/nvidia-uvm-tools none bind,optional,create=file' /etc/pve/lxc/${var.plex_lxcid}.conf || echo 'lxc.mount.entry: /dev/nvidia-uvm-tools dev/nvidia-uvm-tools none bind,optional,create=file' >> /etc/pve/lxc/${var.plex_lxcid}.conf",
      "grep -qxF 'lxc.mount.entry: /dev/dri dev/dri none bind,optional,create=dir' /etc/pve/lxc/${var.plex_lxcid}.conf || echo 'lxc.mount.entry: /dev/dri dev/dri none bind,optional,create=dir' >> /etc/pve/lxc/${var.plex_lxcid}.conf",
      "rm -f ~/.nvidia-driver-version",
      "echo '${var.nvidia_driver_version}' >> ~/.nvidia-driver-version",
      "pct push ${var.plex_lxcid} ~/.nvidia-driver-version /root/.nvidia-driver-version",
      "pct set ${var.plex_lxcid} -mp0 /mnt/pve/media_root/media,mp=/mnt/media",
      "pct set ${var.plex_lxcid} -mp1 /mnt/pve/app_config/plex,mp=/Plex-data",
      "pct reboot ${var.plex_lxcid}",
    ]
  }
}