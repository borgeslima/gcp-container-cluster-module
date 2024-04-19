output "addons_config" {
  value = google_container_cluster.this.addons_config
  description = "The configuration of cluster addons"
}

output "allow_net_admin" {
  value = google_container_cluster.this.allow_net_admin
  description = "Indicates whether network administration is allowed for the cluster"
}

output "cluster_ipv4_cidr" {
  value = google_container_cluster.this.cluster_ipv4_cidr
  description = "The IPv4 CIDR of the cluster"
}

output "datapath_provider" {
  value = google_container_cluster.this.datapath_provider
  description = "The datapath provider of the cluster"
}

output "default_max_pods_per_node" {
  value = google_container_cluster.this.default_max_pods_per_node
  description = "The default maximum number of pods per node"
}

output "deletion_protection" {
  value = google_container_cluster.this.deletion_protection
  description = "Indicates whether deletion protection is enabled for the cluster"
}

output "description" {
  value = google_container_cluster.this.description
  description = "The description of the cluster"
}

output "enable_autopilot" {
  value = google_container_cluster.this.enable_autopilot
  description = "Indicates whether Autopilot is enabled for the cluster"
}

output "enable_cilium_clusterwide_network_policy" {
  value = google_container_cluster.this.enable_cilium_clusterwide_network_policy
  description = "Indicates whether Cilium clusterwide network policy is enabled"
}

output "enable_intranode_visibility" {
  value = google_container_cluster.this.enable_intranode_visibility
  description = "Indicates whether intranode visibility is enabled"
}

output "enable_kubernetes_alpha" {
  value = google_container_cluster.this.enable_kubernetes_alpha
  description = "Indicates whether the Kubernetes alpha version is enabled for the cluster"
}

output "enable_l4_ilb_subsetting" {
  value = google_container_cluster.this.enable_l4_ilb_subsetting
  description = "Indicates whether L4 ILB subsetting is enabled"
}

output "enable_legacy_abac" {
  value = google_container_cluster.this.enable_legacy_abac
  description = "Indicates whether legacy ABAC is enabled for the cluster"
}

output "enable_shielded_nodes" {
  value = google_container_cluster.this.enable_shielded_nodes
  description = "Indicates whether shielded nodes are enabled for the cluster"
}

output "enable_tpu" {
  value = google_container_cluster.this.enable_tpu
  description = "Indicates whether TPUs are enabled for the cluster"
}

output "endpoint" {
  value = google_container_cluster.this.endpoint
  description = "The endpoint of the cluster"
}

output "master_auth" {
  value = google_container_cluster.this.master_auth
  description = "The master authentication credentials of the cluster"
}

output "id" {
  value = google_container_cluster.this.id
  description = "The ID of the cluster"
}

output "initial_node_count" {
  value = google_container_cluster.this.initial_node_count
  description = "The initial number of nodes in the cluster"
}

output "ip_allocation_policy" {
  value = google_container_cluster.this.ip_allocation_policy
  description = "The IP allocation policy of the cluster"
}

output "label_fingerprint" {
  value = google_container_cluster.this.label_fingerprint
  description = "The label fingerprint of the cluster"
}

output "location" {
  value = google_container_cluster.this.location
  description = "The location of the cluster"
}

output "logging_service" {
  value = google_container_cluster.this.logging_service
  description = "The logging service of the cluster"
}

output "maintenance_policy" {
  value = google_container_cluster.this.maintenance_policy
  description = "The maintenance policy of the cluster"
}

output "master_version" {
  value = google_container_cluster.this.master_version
  description = "The Kubernetes master version of the cluster"
}

output "min_master_version" {
  value = google_container_cluster.this.min_master_version
  description = "The minimum Kubernetes master version of the cluster"
}

output "monitoring_service" {
  value = google_container_cluster.this.monitoring_service
  description = "The monitoring service of the cluster"
}

output "name" {
  value = google_container_cluster.this.name
  description = "The name of the cluster"
}

output "network" {
  value = google_container_cluster.this.network
  description = "The network of the cluster"
}

output "networking_mode" {
  value = google_container_cluster.this.networking_mode
  description = "The networking mode of the cluster"
}

output "node_locations" {
  value = google_container_cluster.this.node_locations
  description = "The locations of the cluster's nodes"
}

output "operation" {
  value = google_container_cluster.this.operation
  description = "The operation of the cluster"
}

output "tpu_ipv4_cidr_block" {
  value = google_container_cluster.this.tpu_ipv4_cidr_block
  description = "The IPv4 CIDR block of the cluster's TPUs"
}
