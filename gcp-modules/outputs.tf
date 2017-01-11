output "kubernete_cluster_ip" {
  value = "${module.staging.google_compute_address.kubernetes.address}"
}
