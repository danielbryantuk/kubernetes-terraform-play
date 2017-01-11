provider "google" {
  credentials = "${file(var.credentials_file)}"
  project     = "${var.project_name}"
  region      = "${var.region}"
}

module "kubecontroller" {
  source = "modules/k8scontroller"
  name = "kubecontroller"
}

module "kubeworker" {
  source = "modules/k8sworker"
  name = "kubeworker"
}

module "staging" { #todo - blog passing variables
  source = "./modules/staging"
  name = "staging"
  k8s-controller-links = "${module.kubecontroller.k8s-controller-links}"
}
