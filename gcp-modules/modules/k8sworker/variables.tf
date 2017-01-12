variable "name" {}

variable "k8s_subnet_name" {
  default = "kubernetes"
}

variable "worker_machine_type" {
  default = "n1-standard-1"
}

variable "worker_disk_image" {
  default = "ubuntu-os-cloud/ubuntu-1604-xenial-v20160921"
}

variable "worker_disk_size" {
  default = "200"
}

variable "worker_zone" {
  default = "us-central1-a"
}

variable "worker_ips" {
  default = {
    "0" = "10.240.0.20"
    "1" = "10.240.0.21"
    "2" = "10.240.0.22"
    }
}

variable "instance_ssh_username" {
}

variable "instance_private_key" {
}
