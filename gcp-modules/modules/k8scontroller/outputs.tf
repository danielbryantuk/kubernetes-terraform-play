output "k8s-controllers" {
  value = "${list(google_compute_instance.controller.*.name)}"
}

output "k8s-controller-links" {
  value = "${list(google_compute_instance.controller.*.self_link)}"
}

output "k8s-controllers-network" {
  value = "${list(google_compute_instance.controller.*.network_interface.0.access_config.0.assigned_nat_ip)}"
}
