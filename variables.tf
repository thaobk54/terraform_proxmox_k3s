variable "pm_api_url" {
  description = "Proxmox api endpoint"
  type        = string
  default = "https://192.168.3.10:8006/api2/json"
}

variable "pm_user" {
  description = "Proxmox user"
  type        = string
  default = "root@pam"
}


variable "pm_password" {
  description = "Proxmox password"
  type        = string
}


variable "ssh_user" {
  description = "Default user in Proxmox VM"
  type        = string
  default = "ubuntu"
}


variable "ssh_password" {
  description = "Password for default user in Proxmox VM"
  type        = string
}
