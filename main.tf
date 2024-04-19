
################################################################################
# CLUSTER
################################################################################


resource "google_container_cluster" "this" {
  name                        = var.name
  project                     = var.project
  location                    = try(var.region, "us-east1")
  network                     = try(var.network, "default")
  subnetwork                  = try(var.subnetwork, "default")
  remove_default_node_pool    = try(var.remove_default_node_pool, false)
  initial_node_count          = try(var.initial_node_count, 1)
  enable_l4_ilb_subsetting    = try(var.enable_l4_ilb_subsetting, false)
  default_max_pods_per_node   = try(var.default_max_pods_per_node, 3)
  enable_kubernetes_alpha     = try(var.enable_kubernetes_alpha, false)
  enable_legacy_abac          = try(var.enable_legacy_abac, false)
  enable_intranode_visibility = try(var.enable_intranode_visibility, false)
  deletion_protection         = try(var.deletion_protection, false)

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
  location   = try(var.region, 1)
  node_count = try(each.value.node_count, 1)
  project    = var.project

  autoscaling {
    total_min_node_count = try(each.value.autoscaling.total_min_node_count, 0)
    total_max_node_count = try(each.value.autoscaling.total_max_node_count, 3)
    location_policy      = try(each.value.autoscaling.location_policy, "BALANCED")
  }

  node_config {
    machine_type = try(each.value.node_config.machine_type, "n1-standard-2")
    disk_type    = try(each.value.node_config.disk_type, "30m")
    disk_size_gb = try(each.value.node_config.disk_size_gb, 40)
    preemptible  = try(each.value.node_config.preemptible, false)
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

    tags     = try(each.value.node_config.tags, {})
    metadata = try(each.value.node_config.metadata, {})
    labels   = try(each.value.node_config.labels, {})
  }

  timeouts {
    create = try(each.value.timeouts.create, "30m")
    update = try(each.value.timeouts.update, "30m")
  }
}


