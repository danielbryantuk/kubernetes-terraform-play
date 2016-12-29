provider "google" {
  credentials = "${file("account.json")}"
  project     = "k8s-leap-forward"
  region      = "us-central1"
}
