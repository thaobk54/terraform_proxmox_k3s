terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.3"
    }

    macaddress = {
      source = "ivoronin/macaddress"
      version = "0.3.0"
    }
  }
}

locals {
  # Promox configuration
  pm_api_url = var.pm_api_url
  pm_user = var.pm_user
  pm_password = var.pm_password

  # SSH Password Authentication
  ssh_user = var.ssh_user
  ssh_password = var.ssh_password
}

provider proxmox {
  pm_log_enable = true
  pm_log_file = "terraform-plugin-proxmox.log"
  pm_debug = true
  pm_log_levels = {
    _default = "debug"
    _capturelog = ""
  }

  pm_api_url = local.pm_api_url
  pm_user = local.pm_user
  pm_password = local.pm_password
}

module "k3s" {
  source = "./modules/proxmox-k3s" 

  authorized_keys_file = ""

  proxmox_node = "agileops182"

  node_template = "ubuntu-2004-cloudinit-template"
  proxmox_resource_pool = "k3s"

  network_gateway = "10.182.4.1"
  lan_subnet = "10.182.4.0/24"

  support_node_settings = {
    cores = 2
    memory = 4096
    user = local.ssh_user
    password = local.ssh_password
    storage_id = "local-lvm"
  }


  master_nodes_count = 1
  master_node_settings = {
    cores = 4
    memory = 8192
    user = local.ssh_user
    password = local.ssh_password
    storage_id = "local-lvm"
  }

  # 10.182.4.200 -> 10.182.4.207 (6 available IPs for nodes)
  control_plane_subnet = "10.182.4.200/29"
  node_pools = [
    {
      name = "worker"
      size = 3
     # 10.182.4.208 -> 10.182.4.223 (14 available IPs for nodes)
      subnet = "10.182.4.208/28"
      user = local.ssh_user
      password = local.ssh_password
      cores = 4
      memory = 16384,
      // Boot disk
      boot_storage_type = "scsi"
      boot_storage_id = "local-lvm"
      boot_disk_size = "20G"
      // Additional disk for OpenEBS or LongHorn
      storage_type = "virtio"
      storage_id = "local-lvm"
      disk_size = "100G"
    }
  ]

    # Disable default traefik and servicelb installs for metallb and traefik 2
  k3s_disable_components = [
    "traefik",
    "servicelb"
  ]
}

# output "kubeconfig" {
#   value = module.k3s.k3s_kubeconfig
#   sensitive = true
# }

