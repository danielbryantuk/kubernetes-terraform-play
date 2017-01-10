provider "google" {
  credentials = "${file(var.credentials_file)}"
  project     = "${var.project_name}"
  region      = "${var.region}"
}

module "k8s-controller" {
  source = "./modules/k8s-controller"
  name = "k8s-controller"
}

module "k8s-worker" {
  source = "./modules/k8s-worker"
  name = "k8s-worker"
}

module "staging" {
  source = "./modules/staging"
  name = "staging"
}
