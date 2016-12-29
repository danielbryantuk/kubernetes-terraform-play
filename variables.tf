variable "instance_ssh_username" {  
}

variable "instance_private_key" {
}

variable "controller_ips" {
  default = {
    "0" = "10.240.0.10"
    "1" = "10.240.0.11"
    "2" = "10.240.0.12"
    }
}

variable "worker_ips" {
  default = {
    "0" = "10.240.0.20"
    "1" = "10.240.0.21"
    "2" = "10.240.0.22"
    }
}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "disk_image" {
  default = "ubuntu-os-cloud/ubuntu-1604-xenial-v20160921"
}

variable "disk_size" {
  default = "200"
}
