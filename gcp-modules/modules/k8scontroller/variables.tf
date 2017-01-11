variable "name" {}

variable "k8s_subnet_name" {
  default = "kubernetes"
}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "disk_image" {
  default = "ubuntu-os-cloud/ubuntu-1604-xenial-v20160921"
}

variable "disk_size" {
  default = "200"
}

variable "zone" {
  default = "us-central1-a"
}

variable "controller_ips" {
  default = {
    "0" = "10.240.0.10"
    "1" = "10.240.0.11"
    "2" = "10.240.0.12"
    }
}
