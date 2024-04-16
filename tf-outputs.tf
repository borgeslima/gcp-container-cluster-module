output "name" {
  value = google_container_cluster.this.name
}

output "cluster_ca_certificate" {
  value = google_container_cluster.this.master_auth[0].cluster_ca_certificate
}

output "endpoint" {
  value = google_container_cluster.this.endpoint
}