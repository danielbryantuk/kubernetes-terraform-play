output "kubernete_cluster_ip" {
  value = "${google_compute_address.kubernetes.address}"
}
