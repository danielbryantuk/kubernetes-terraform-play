output "k8s-network-address" {
  value = "${google_compute_address.kubernetes.address}"
}
