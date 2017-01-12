output "kubernete_cluster_ip" {
  value = "${module.staging.k8s-network-address}"
}
