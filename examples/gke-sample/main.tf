################################################################################
# VARIABLES LOCAL
################################################################################

locals {
  name    = "quark-labs"
  region  = "us-east1"
  project = "quark-labs"
}

################################################################################
# NETWORK
################################################################################


module "network" {
  source                  = "git::https://github.com/quarks-labs/gcp-network-module.git"
  region                  = local.region
  name                    = local.name
  project                 = local.project
  auto_create_subnetworks = true

  subnetworks = [{
    name                     = "default-01"
    region                   = "us-east1"
    ip_cidr_range            = "172.28.0.0/27"
    private_ip_google_access = false
    nat = {
      nat_ip_allocate_option             = "MANUAL_ONLY"
      source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
    }
    secondary_ip_ranges = [
      {
        range_name    = "primary"
        ip_cidr_range = "172.1.16.0/20"
      },
      {
        range_name    = "secondary"
        ip_cidr_range = "172.1.32.0/20"
      }
    ]
    }
  ]
}

################################################################################
# GKE
################################################################################


module "gke" {
  source              = "../.."
  region              = local.region
  name                = local.name
  project             = local.project
  network             = module.network.network_self_link
  subnetwork          = module.network.subnetwork_self_link[0]
  deletion_protection = false

  addons_config = {
    gce_persistent_disk_csi_driver_config = {
      enabled = true
    }
    http_load_balancing = {
      disable = false
    }
    network_policy_config = {
      disabled = false
    }
  }

  ip_allocation_policy = {
    cluster_secondary_range_name  = tostring([for ips in module.network.subnetwork_secondary_ip_ranges : ips][0][0])
    services_secondary_range_name = tostring([for ips in module.network.subnetwork_secondary_ip_ranges : ips][0][1])
  }

  maintenance_policy = {
    daily_maintenance_window = {
      start_time = "03:00"
    }
  }

  node_pools = [{
    name       = "node-pool-01"
    node_count = 1
    autoscaling = {
      total_min_node_count = 1
      total_max_node_count = 3
      location_policy      = "BALANCED"
    }
    node_config = {
      machine_type = "n1-standard-1"
      disk_type    = "pd-ssd"
      disk_size_gb = 20
      preemptible  = false
      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform",
      ]
      tags     = []
      metadata = {}
      labels   = {}
    }
    timeouts = {
      create = "30m"
      update = "30m"
    }
  }]
  depends_on = [module.network]
}

data "google_client_config" "provider" {}
