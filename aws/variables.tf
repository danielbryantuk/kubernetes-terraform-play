variable "aws_access_key" {
}

variable "aws_secret_key" {
}

variable "region" {
}

variable "instance_ssh_username" {
}

variable "instance_private_key_file" {
}

variable "instance_public_key_contents" {
}

variable "instance_image" {
  default = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"
}

variable "instance_image_provider_id" {
  default = "099720109477" #Canonical
}

variable "ansible_playbook_file_location" {
  default = "../ansible/site.yaml"
}

variable "templates_location" {
  default = "../terraform-templates/"
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

variable "instance_type" {
  default = "t2.small"
}

variable "k8s_vpc_cidr" {
  default = "10.240.0.0/16"
}

variable "k8s_vpc_subnet" {
  default = "10.240.0.0/24"
}

variable "dhcp_domain_name" {
  default = "eu-west-1.compute.internal"
}

variable "dhcp_domain_name_servers" {
  default = ["AmazonProvidedDNS"]
}
