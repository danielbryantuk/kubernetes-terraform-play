provider "google" {
  credentials = "${file(var.credentials_file)}"
  project     = "${var.project_name}"
  region      = "${var.region}"
}

module "k8scontroller" {
  source = "modules/k8scontroller"
  name = "k8scontroller"
}

module "k8sworker" {
  source = "modules/k8sworker"
  name = "k8sworker"
}

module "staging" { #todo - blog passing variables
  source = "./modules/staging"
  name = "staging"
  k8s-controller-links = "${module.k8scontroller.k8s-controller-links}"
}
