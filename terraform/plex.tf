resource "proxmox_lxc" "plex" {
  target_node     = "hades"
  hostname        = "plex"
  ostemplate      = "/mnt/pve/iso/template/cache/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  unprivileged    = true
  ostype          = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start           = true
  onboot          = true
  vmid            = var.plex_lxcid
  memory          = 1024
  cores           = 2
  nameserver      = var.gateway_ip

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "4G"
  }

  mountpoint {
    mp      = "/Plex-data"
    size    = "8G"
    slot    = 0
    key     = "0"
    storage = "/mnt/pve/app_data/plex"
    volume  = "/mnt/pve/app_data/plex"
  }

  mountpoint {
    mp      = "/mnt/pve/media/media"
    size    = "4000G"
    slot    = 1
    key     = "1"
    storage = "/mnt/pve/media/media"
    volume  = "/mnt/pve/media/media"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    gw     = var.gateway_ip
    ip     = var.plex_ip
    ip6    = "auto"
    hwaddr = var.plex_mac
  }

  lifecycle {
    ignore_changes = [
      mountpoint[0].storage,
      mountpoint[1].storage
    ]
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = var.proxmox_password
      host     = var.hades_address
    }
    inline = [
      "grep -qxF 'lxc.cgroup2.devices.allow: c 195:* rwm' /etc/pve/lxc/${var.plex_lxcid}.conf || echo 'lxc.cgroup2.devices.allow: c 195:* rwm' >> /etc/pve/lxc/${var.plex_lxcid}.conf",
      "grep -qxF 'lxc.cgroup2.devices.allow: c 509:* rwm' /etc/pve/lxc/${var.plex_lxcid}.conf || echo 'lxc.cgroup2.devices.allow: c 509:* rwm' >> /etc/pve/lxc/${var.plex_lxcid}.conf",
      "grep -qxF 'lxc.cgroup2.devices.allow: c 226:* rwm' /etc/pve/lxc/${var.plex_lxcid}.conf || echo 'lxc.cgroup2.devices.allow: c 226:* rwm' >> /etc/pve/lxc/${var.plex_lxcid}.conf",
      "grep -qxF 'lxc.mount.entry: /dev/nvidia0 dev/nvidia0 none bind,optional,create=file' /etc/pve/lxc/${var.plex_lxcid}.conf || echo 'lxc.mount.entry: /dev/nvidia0 dev/nvidia0 none bind,optional,create=file' >> /etc/pve/lxc/${var.plex_lxcid}.conf",
      "grep -qxF 'lxc.mount.entry: /dev/nvidiactl dev/nvidiactl none bind,optional,create=file' /etc/pve/lxc/${var.plex_lxcid}.conf || echo 'lxc.mount.entry: /dev/nvidiactl dev/nvidiactl none bind,optional,create=file' >> /etc/pve/lxc/${var.plex_lxcid}.conf",
      "grep -qxF 'lxc.mount.entry: /dev/nvidia-uvm dev/nvidia-uvm none bind,optional,create=file' /etc/pve/lxc/${var.plex_lxcid}.conf || echo 'lxc.mount.entry: /dev/nvidia-uvm dev/nvidia-uvm none bind,optional,create=file' >> /etc/pve/lxc/${var.plex_lxcid}.conf",
      "grep -qxF 'lxc.mount.entry: /dev/nvidia-modeset dev/nvidia-modeset none bind,optional,create=file' /etc/pve/lxc/${var.plex_lxcid}.conf || echo 'lxc.mount.entry: /dev/nvidia-modeset dev/nvidia-modeset none bind,optional,create=file' >> /etc/pve/lxc/${var.plex_lxcid}.conf",
      "grep -qxF 'lxc.mount.entry: /dev/nvidia-uvm-tools dev/nvidia-uvm-tools none bind,optional,create=file' /etc/pve/lxc/${var.plex_lxcid}.conf || echo 'lxc.mount.entry: /dev/nvidia-uvm-tools dev/nvidia-uvm-tools none bind,optional,create=file' >> /etc/pve/lxc/${var.plex_lxcid}.conf",
      "grep -qxF 'lxc.mount.entry: /dev/dri dev/dri none bind,optional,create=dir' /etc/pve/lxc/${var.plex_lxcid}.conf || echo 'lxc.mount.entry: /dev/dri dev/dri none bind,optional,create=dir' >> /etc/pve/lxc/${var.plex_lxcid}.conf",
      "rm -f ~/.nvidia-driver-version",
      "echo '${var.nvidia_driver_version}' >> ~/.nvidia-driver-version",
      "pct push ${var.plex_lxcid} ~/.nvidia-driver-version /root/.nvidia-driver-version"
    ]
  }
}