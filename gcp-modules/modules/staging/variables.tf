variable "name" {}

variable "k8s-controller-links" {}

variable "network_name" {
  default = "kubernetes"
}

variable "k8s_subnet_ip_cidr_range" {
  default = "10.240.0.0/24"
}
