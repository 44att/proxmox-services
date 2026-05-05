variable "vault_address" {
  description = "The address of the Vault server"
  type        = string
  default     = "http://127.0.0.1:8200"
}

variable "vault_token" {
  description = "Vault authentication token"
  type        = string
  sensitive   = true  # Prevents value from appearing in logs
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "pve1_address" {
  description = "The Proxmox host address for pve1 node"
  type        = string
  default     = "10.1.7.2"
}

variable "pve2_address" {
  description = "The Proxmox host address for pve2 node"
  type        = string
  default     = "10.1.7.3"
}

variable "pve1_api_url" {
  description = "The Proxmox API URL for pve1 node"
  type        = string
  default     = "https://10.1.7.2:8006/api2/json"
}

variable "pve2_api_url" {
  description = "The Proxmox API URL for pve2 node"
  type        = string
  default     = "https://10.1.7.3:8006/api2/json"
}

variable "proxmox_user" {
  description = "The Proxmox user"
  type        = string
  default     = "root@pam"
}

variable "pub_ssh_key" {
  description = "Public SSH key for passwordless login/Ansible admining"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "gateway_ip" {
  description = "LXC gateway IP"
  type        = string
  default     = "10.1.7.1"
}

variable "vpn_gateway_ip" {
  description = "LXC gateway IP for VPN network"
  type        = string
  default     = "10.1.10.1"
}

variable "nvidia_driver_version" {
  description = "Nvidia driver version"
  type        = string
  default     = "580.119.02"
}

//
// Services variables
//

variable "pi-hole_lxcid" {
  type    = number
  default = 100
}

variable "cockpit_lxcid" {
  type    = number
  default = 200
}

variable "mafl_lxcid" {
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

variable "jellyseerr_lxcid" {
  type    = number
  default = 502
}

variable "prowlarr_lxcid" {
  type    = number
  default = 503
}

variable "bazarr_lxcid" {
  type    = number
  default = 504
}

variable "sonarr_lxcid" {
  type    = number
  default = 505
}

variable "radarr_lxcid" {
  type    = number
  default = 506
}

variable "sabnzbd_lxcid" {
  type    = number
  default = 507
}

variable "recyclarr_lxcid" {
  type    = number
  default = 508
}

variable "plex_lxcid" {
  type    = number
  default = 509
}

variable "seerr_lxcid" {
  type    = number
  default = 510
}

variable "wireguard_lxcid" {
  type    = number
  default = 302
}

variable "openwrt_lxcid" {
  type    = number
  default = 301
}

variable "tailscale_lxcid" {
  type    = number
  default = 200
}

variable "syncthing_lxcid" {
  type    = number
  default = 201
}

variable "cookcli_lxcid" {
  type    = number
  default = 511
}

variable "donetick_lxcid" {
  type    = number
  default = 512
}

variable "traefik_mac" {
  type    = string
  default = "B6:1A:E1:C6:86:03"
}

variable "bazarr_mac" {
  type    = string
  default = "EA:E4:60:8F:7F:B7"
}

variable "jellyseerr_mac" {
  type    = string
  default = "76:B4:86:28:A1:B4"
}

variable "seerr_mac" {
  type    = string
  default = "82:56:ec:6b:8e:04"
}

variable "sonarr_mac" {
  type    = string
  default = "F2:07:09:E7:05:32"
}

variable "radarr_mac" {
  type    = string
  default = "36:67:C0:9C:48:9C"
}

variable "sabnzbd_mac" {
  type    = string
  default = "12:E8:11:73:7E:38"
}

variable "cockpit_mac" {
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

variable "network_mac" {
  type    = string
  default = "42:98:73:F5:A2:A8"
}

variable "recyclarr_mac" {
  type    = string
  default = "9A:02:CA:A5:37:8C"
}

variable "plex_mac" {
  type    = string
  default = "3A:8F:F6:96:dC:84"
}

variable "mafl_mac" {
  type    = string
  default = "e6:74:a0:6c:31:13"
}

variable "tailscale_mac" {
  type    = string
  default = "32:a1:07:95:ce:81"
}

variable "syncthing_mac" {
  type    = string
  default = "4a:d2:cc:4f:e6:b4"
}

variable "cookcli_mac" {
  type    = string
  default = "a2:49:3b:c9:78:a2"
}

variable "donetick_mac" {
  type    = string
  default = "92:d6:b0:ce:49:ff"
}

variable "pi-hole-primary_ip" {
  type    = string
  default = "10.1.7.98/24"
}

variable "pi-hole-secondary_ip" {
  type    = string
  default = "10.1.7.99/24"
}

variable "traefik_ip" {
  type    = string
  default = "10.1.7.17/24"
}

variable "jellyseerr_ip" {
  type    = string
  default = "10.1.7.9/24"
}

variable "seerr_ip" {
  type    = string
  default = "10.1.7.18/24"
}

variable "sonarr_ip" {
  type    = string
  default = "10.1.7.15/24"
}

variable "radarr_ip" {
  type    = string
  default = "10.1.7.16/24"
}

variable "prowlarr_ip" {
  type    = string
  default = "10.1.7.11/24"
}

variable "sabnzbd_ip" {
  type    = string
  default = "10.1.7.13/24"
}

variable "bazarr_ip" {
  type    = string
  default = "10.1.7.14/24"
}

variable "cockpit_ip" {
  type    = string
  default = "10.1.7.8/24"
}

variable "network_ip" {
  type    = string
  default = "10.1.7.6/24"
}

variable "recyclarr_ip" {
  type    = string
  default = "10.1.7.12/24"
}

variable "plex_ip" {
  type    = string
  default = "10.1.7.10/24"
}

variable "wireguard_ip" {
  type    = string
  default = "10.1.10.2/24"
}

variable "openwrt_ip" {
  type    = string
  default = "10.1.7.97/24"
}

variable "tailscale_ip" {
  type    = string
  default = "10.1.7.96/24"
}

variable "mafl_ip" {
  type    = string
  default = "10.1.7.19/24"
}

variable "syncthing_ip" {
  type    = string
  default = "10.1.7.20/24"
}

variable "cookcli_ip" {
  type    = string
  default = "10.1.7.21/24"
}

variable "donetick_ip" {
  type    = string
  default = "10.1.7.22/24"
}
