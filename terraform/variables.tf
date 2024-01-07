variable "apollo_address" {
  description = "The Proxmox host address for Apollo node"
  type        = string
  default     = "192.168.1.10"
}

variable "hades_address" {
  description = "The Proxmox host address for Hades node"
  type        = string
  default     = "192.168.1.14"
}

variable "apollo_api_url" {
  description = "The Proxmox API URL for Apollo node"
  type        = string
  default     = "https://192.168.1.10:8006/api2/json"
}

variable "hades_api_url" {
  description = "The Proxmox API URL for Hades node"
  type        = string
  default     = "https://192.168.1.14:8006/api2/json"
}

variable "proxmox_user" {
  description = "The Proxmox user"
  type        = string
  default     = "root@pam"
}

variable "proxmox_password" {
  description = "The Proxmox user password"
  type        = string
}

variable "pub_ssh_key" {
  description = "Public SSH key for passwordless login/Ansible admining"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "gateway_ip" {
  description = "LXC gateway IP"
  type        = string
  default     = "192.168.1.1"
}

variable "gateway_ip_vlan_10" {
  description = "LXC gateway IP for VLAN 10"
  type        = string
  default     = "192.168.10.1"
}

variable "gateway_ip_vlan_20" {
  description = "LXC gateway IP for VLAN 20"
  type        = string
  default     = "192.168.20.1"
}

variable "nvidia_driver_version" {
  description = "Nvidia driver version"
  type        = string
  default     = "470.103.01"
}

//
// Services variables
//

variable "pi-hole-primary_lxcid" {
  type    = number
  default = 100
}

variable "pi-hole-secondary_lxcid" {
  type    = number
  default = 200
}

variable "homepage_lxcid" {
  type    = number
  default = 400
}

variable "network_lxcid" {
  type    = number
  default = 500
}

variable "traefik_lxcid" {
  type    = number
  default = 501
}

variable "jellyfin_lxcid" {
  type    = number
  default = 502
}

variable "jellyseerr_lxcid" {
  type    = number
  default = 503
}

variable "prowlarr_lxcid" {
  type    = number
  default = 504
}

variable "bazarr_lxcid" {
  type    = number
  default = 505
}

variable "sonarr_lxcid" {
  type    = number
  default = 506
}

variable "radarr_lxcid" {
  type    = number
  default = 507
}

variable "lidarr_lxcid" {
  type    = number
  default = 508
}

variable "tdarr_lxcid" {
  type    = number
  default = 509
}

variable "sabnzbd_lxcid" {
  type    = number
  default = 510
}

variable "qbittorrent_lxcid" {
  type    = number
  default = 511
}

variable "navidrome_lxcid" {
  type    = number
  default = 512
}

variable "recyclarr_lxcid" {
  type    = number
  default = 513
}

variable "threadfin_lxcid" {
  type    = number
  default = 514
}

variable "plex_lxcid" {
  type    = number
  default = 515
}

variable "upgradinatorr_lxcid" {
  type    = number
  default = 516
}

variable "docker_lxcid" {
  type    = number
  default = 515
}

variable "keycloak_lxcid" {
  type    = number
  default = 516
}

variable "syncthing_lxcid" {
  type    = number
  default = 517
}

variable "wireguard_lxcid" {
  type    = number
  default = 518
}

variable "rclone_lxcid" {
  type    = number
  default = 519
}

variable "samba_lxcid" {
  type    = number
  default = 520
}

variable "crowdsec_lxcid" {
  type    = number
  default = 599
}

variable "homepage_mac" {
  type    = string
  default = "2E:08:E2:3F:BE:36"
}

variable "traefik_mac" {
  type    = string
  default = "B6:1A:E1:C6:86:03"
}

variable "bazarr_mac" {
  type    = string
  default = "EA:E4:60:8F:7F:B7"
}

variable "jellyfin_mac" {
  type    = string
  default = "7A:25:2B:1B:BE:EF"
}

variable "jellyseerr_mac" {
  type    = string
  default = "76:B4:86:28:A1:B4"
}

variable "sonarr_mac" {
  type    = string
  default = "F2:07:09:E7:05:32"
}

variable "radarr_mac" {
  type    = string
  default = "36:67:C0:9C:48:9C"
}

variable "qbittorrent_mac" {
  type    = string
  default = "EE:28:5A:1B:D5:DD"
}

variable "sabnzbd_mac" {
  type    = string
  default = "12:E8:11:73:7E:38"
}

variable "samba_mac" {
  type    = string
  default = "CE:04:BF:59:F1:7F"
}

variable "pi-hole-primary_mac" {
  type    = string
  default = "BA:B8:76:70:58:90"
}

variable "pi-hole-secondary_mac" {
  type    = string
  default = "02:58:BD:D4:C1:FC"
}

variable "prowlarr_mac" {
  type    = string
  default = "06:90:EE:CD:05:87"
}

variable "tdarr_mac" {
  type    = string
  default = "2A:F0:E4:07:39:3B"
}

variable "network_mac" {
  type    = string
  default = "42:98:73:F5:A2:A8"
}

variable "docker_mac" {
  type    = string
  default = "F6:82:27:AF:F1:47"
}

variable "lidarr_mac" {
  type    = string
  default = "F6:1D:39:81:48:4C"
}

variable "navidrome_mac" {
  type    = string
  default = "26:18:8A:49:40:33"
}

variable "recyclarr_mac" {
  type    = string
  default = "9A:02:CA:A5:37:8C"
}

variable "threadfin_mac" {
  type    = string
  default = "E2:80:96:E4:9E:7d"
}

variable "plex_mac" {
  type    = string
  default = "3A:8F:F6:96:dC:84"
}

variable "upgradinatorr_mac" {
  type    = string
  default = "aa:4f:68:04:d0:19"
}

variable "crowdsec_mac" {
  type    = string
  default = "7A:65:CB:DB:E0:12"
}

variable "pi-hole-primary_ip" {
  type    = string
  default = "192.168.1.20/24"
}

variable "pi-hole-secondary_ip" {
  type    = string
  default = "192.168.1.21/24"
}

variable "crowdsec_ip" {
  type    = string
  default = "192.168.1.22/24"
}

variable "traefik_ip" {
  type    = string
  default = "192.168.1.29/24"
}

variable "jellyfin_ip" {
  type    = string
  default = "192.168.1.30/24"
}

variable "jellyseerr_ip" {
  type    = string
  default = "192.168.1.31/24"
}

variable "sonarr_ip" {
  type    = string
  default = "192.168.1.34/24"
}

variable "radarr_ip" {
  type    = string
  default = "192.168.1.35/24"
}

variable "prowlarr_ip" {
  type    = string
  default = "192.168.1.32/24"
}

variable "sabnzbd_ip" {
  type    = string
  default = "192.168.10.30/24"
}

variable "qbittorrent_ip" {
  type    = string
  default = "192.168.10.31/24"
}

variable "threadfin_ip" {
  type    = string
  default = "192.168.10.32/24"
}


variable "bazarr_ip" {
  type    = string
  default = "192.168.1.33/24"
}

variable "samba_ip" {
  type    = string
  default = "192.168.1.27/24"
}

variable "network_ip" {
  type    = string
  default = "192.168.1.28/24"
}

variable "tdarr_ip" {
  type    = string
  default = "192.168.1.37/24"
}

variable "navidrome_ip" {
  type    = string
  default = "192.168.1.38/24"
}

variable "recyclarr_ip" {
  type    = string
  default = "192.168.1.39/24"
}

variable "plex_ip" {
  type    = string
  default = "192.168.1.40/24"
}

variable "upgradinatorr_ip" {
  type    = string
  default = "192.168.1.41/24"
}

variable "docker_ip" {
  type    = string
  default = "192.168.1.34/24"
}

variable "syncthing_ip" {
  type    = string
  default = "192.168.1.39/24"
}

variable "lidarr_ip" {
  type    = string
  default = "192.168.1.36/24"
}

variable "wireguard_ip" {
  type    = string
  default = "192.168.1.39/24"
}

variable "rclone_ip" {
  type    = string
  default = "192.168.1.41/24"
}

variable "homepage_ip" {
  type    = string
  default = "192.168.1.16/24"
}
