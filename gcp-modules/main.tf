provider "google" {
  credentials = "${file(var.credentials_file)}"
  project     = "${var.project_name}"
  region      = "${var.region}"
}

module "kubecontroller" {
  source = "modules/k8scontroller"
  name = "kubecontroller"
  instance_ssh_username = "${var.instance_ssh_username}"
  instance_private_key = "${var.instance_private_key}"
}

module "kubeworker" {
  source = "modules/k8sworker"
  name = "kubeworker"
  instance_ssh_username = "${var.instance_ssh_username}"
  instance_private_key = "${var.instance_private_key}"
}

module "staging" { #todo - blog passing variables
  source = "./modules/staging"
  name = "staging"
  k8s-controller-links = "${module.kubecontroller.k8s-controller-links}"
}
