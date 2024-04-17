variable "region" {
  type        = string
  description = "GCP Region"
}

variable "name" {
  type        = string
  description = "Name of GCP Network"
}

variable "project" {
  type        = string
  description = "Name of GCP Network"
}

variable "network" {
  type        = any
  description = "network"
}

variable "subnetwork" {
  type        = any
  description = "List of GCP Subnetworks"
}

variable "remove_default_node_pool" {
  type        = bool
  description = "Remove default node Pool"
}

variable "initial_node_count" {
  type        = number
  description = "Number of node default"
}

variable "enable_l4_ilb_subsetting" {
  type        = bool
  description = "Enable l4_ilb support"
}

variable "service_external_ips_config" {
  type = object({
    enabled = bool
  })
  description = "Service External IP configuration"
  default = {
    enabled = false
  }
}

variable "default_max_pods_per_node" {
  type        = number
  description = "Max of pods per node"
}

variable "enable_kubernetes_alpha" {
  type        = bool
  description = "Enabled Kubernetes Alpha"
}

variable "enable_legacy_abac" {
  type        = bool
  description = "Enable Legacy abac"
}

variable "addons_config" {
  type = object({
    http_load_balancing = object({
      disable = bool
    })
    gce_persistent_disk_csi_driver_config = object({
      enabled = bool
    })
    network_policy_config = object({
      disabled = bool
    })
  })
  description = "Config GKE Addons"
  default = {
    http_load_balancing = {
      disable = false
    }

    gce_persistent_disk_csi_driver_config = {
      enabled = true
    }

    network_policy_config = {
      disabled = false
    }
  }
}

variable "maintenance_policy" {
  type = object({
    daily_maintenance_window = object({
      start_time = string
    })
  })
  description = "GKE Maintence policy"
}

variable "private_cluster_config" {
  type = object({
    enable_private_endpoint = bool
    enable_private_nodes    = bool
    master_ipv4_cidr_block  = string
    master_global_access_config = object({
      enabled = bool
    })
  })
  description = "GKE Private configurations"
  default = {
    enable_private_endpoint = false
    enable_private_nodes    = false
    master_ipv4_cidr_block  = ""
    master_global_access_config = {
      enabled = false
    }
  }
}

variable "enable_intranode_visibility" {
  type        = bool
  description = "Enable intranode visibility"
}

variable "network_policy" {
  type = object({
    enabled  = bool
    provider = string
  })
  description = "Network policies"
  default = {
    enabled  = true
    provider = "CALICO"
  }
}

variable "ip_allocation_policy" {
  type = object({
    cluster_secondary_range_name  = string
    services_secondary_range_name = string
  })
  description = "Allocation ip Policy"
}

variable "master_auth" {
  type = object({
    client_certificate_config = object({
      issue_client_certificate = bool
    })
  })
  description = "Master auth configuration"
}


variable "node_pools" {
  type = list(object({
    name       = string
    node_count = number
    autoscaling = object({
      total_min_node_count = number
      total_max_node_count = number
      location_policy      = string
    })
    node_config = object({
      machine_type = string
      disk_type    = string
      disk_size_gb = number
      preemptible  = bool
      oauth_scopes = set(string)
      tags         = list(string)
      metadata     = map(string)
      labels       = map(string)
    })
    timeouts = object({
      create = string
      update = string
    })
  }))

  description = "Node pool configuration"
}

