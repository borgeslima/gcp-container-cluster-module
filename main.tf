
################################################################################
# CLUSTER
################################################################################


resource "google_container_cluster" "this" {
  name                     = var.name
  location                 = var.region
  project                  = var.project
  remove_default_node_pool = try(var.remove_default_node_pool, false)
  initial_node_count       = try(var.initial_node_count, 1)
  
  network                  = var.network
  subnetwork               = var.subnetwork

  enable_l4_ilb_subsetting = try(var.enable_l4_ilb_subsetting, false)
  default_max_pods_per_node = try(var.default_max_pods_per_node, 3)
  enable_kubernetes_alpha   = try(var.enable_kubernetes_alpha, false)
  enable_legacy_abac =        try(var.enable_legacy_abac, false)
  enable_intranode_visibility = try(var.enable_intranode_visibility, false)



  master_auth {
    client_certificate_config {
      issue_client_certificate = try(var.master_auth.client_certificate_config.issue_client_certificate, true)
    }
  }


  ip_allocation_policy {
    cluster_secondary_range_name  = try(var.ip_allocation_policy.cluster_secondary_range_name, "")
    services_secondary_range_name = try(var.ip_allocation_policy.services_secondary_range_name, "")
  }



  service_external_ips_config {
    enabled = try(var.service_external_ips_config.enabled, false)
  }

  addons_config {

    http_load_balancing {
      disabled = try(var.addons_config.http_load_balancing.disable, false)
    }

    gce_persistent_disk_csi_driver_config {
      enabled = try(var.addons_config.gce_persistent_disk_csi_driver_config.enabled, false)
    }

    network_policy_config {
      disabled = try(var.addons_config.network_policy_config.disabled, false)
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = try(var.maintenance_policy.daily_maintenance_window.start_time, "03:00")
    }
  }

  private_cluster_config {
    enable_private_endpoint = try(var.private_cluster_config.enable_private_endpoint, false)
    enable_private_nodes    = try(var.private_cluster_config.enable_private_nodes, false)
    master_ipv4_cidr_block  = try(var.private_cluster_config.master_ipv4_cidr_block, "")

    master_global_access_config {
      enabled = try(var.private_cluster_config.master_global_access_config.enabled, false)
    }
  }

  network_policy {
    enabled  = try(var.network_policy.enabled, true)
    provider = try(var.network_policy.provider, "CALICO")
  }
}

################################################################################
# NODE-POOL
################################################################################


resource "google_container_node_pool" "this" {
    
  for_each = { for idx, pool in var.node_pools : idx => pool }

  name       = each.value.name
  cluster    = google_container_cluster.this.name
  location   = var.region
  node_count = each.value.node_count
  project    = var.project

  autoscaling {
    total_min_node_count = each.value.autoscaling.total_min_node_count
    total_max_node_count = each.value.autoscaling.total_max_node_count
    location_policy      = each.value.autoscaling.location_policy
  }

  node_config {
    machine_type = each.value.node_config.machine_type
    disk_type    = each.value.node_config.disk_type
    disk_size_gb = each.value.node_config.disk_size_gb
    preemptible  = each.value.node_config.preemptible
    oauth_scopes = try(each.value.node_config.oauth_scopes, toset([
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/cloud-platform",
    ]))

    


    tags     = each.value.node_config.tags
    metadata = each.value.node_config.metadata
    labels   = each.value.node_config.labels
  }

  timeouts {
    create = each.value.timeouts.create
    update = each.value.timeouts.update
  }
}


