output "k8s-workers" {
  value = "${list(google_compute_instance.worker.*.name)}"
}

output "k8s-workers-network" {
  value = "${list(google_compute_instance.worker.*.network_interface.0.access_config.0.assigned_nat_ip)}"
}
