provider "google" {
  credentials = "${file("account.json")}"
  project     = "k8s-leap-forward"
  region      = "us-central1"
}

resource "google_compute_network" "kubernetes" {
  name = "kubernetes"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "kubernetes" {
  name = "kubernetes"
  ip_cidr_range = "10.240.0.0/24"
  network = "${google_compute_network.kubernetes.self_link}"
}

resource "google_compute_firewall" "kubernetes-allow-icmp" {
  name = "kubernetes-allow-icmp"
  network = "${google_compute_network.kubernetes.name}"

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "kubernetes-allow-internal" {
  name = "kubernetes-allow-internal"
  network = "${google_compute_network.kubernetes.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports = ["0-65535"]
  }

  source_ranges = ["10.240.0.0/24"]
}

resource "google_compute_firewall" "kubernetes-allow-rdp" {
  name = "kubernetes-allow-rdp"
  network = "${google_compute_network.kubernetes.name}"

  allow {
    protocol = "tcp"
    ports = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "kubernetes-allow-ssh" {
  name = "kubernetes-allow-ssh"
  network = "${google_compute_network.kubernetes.name}"

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "kubernetes-allow-healthz" {
  name = "kubernetes-allow-health"
  network = "${google_compute_network.kubernetes.name}"

  allow {
    protocol = "tcp"
    ports = ["8080"]
  }

  source_ranges = ["130.211.0.0/22"]
}

resource "google_compute_firewall" "kubernetes-allow-api-server" {
  name = "kubernetes-allow-api-server"
  network = "${google_compute_network.kubernetes.name}"

  allow {
    protocol = "tcp"
    ports = ["6443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "kubernetes" {
  name = "kubernetes"
}

variable "controller_ips" {
  default = {
    "0" = "10.240.0.10"
    "1" = "10.240.0.11"
    "2" = "10.240.0.12"
    }
}

resource "google_compute_instance" "controller" {
  count = 3
  name = "controller${count.index}"
  machine_type = "n1-standard-1"
  zone = "us-central1-a"

  disk {
    image = "ubuntu-os-cloud/ubuntu-1604-xenial-v20160921"
    size = "200"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kubernetes.name}"
    address = "${lookup(var.controller_ips, count.index)}"
    access_config {
    }
  }

  can_ip_forward = true
}

variable "worker_ips" {
  default = {
    "0" = "10.240.0.20"
    "1" = "10.240.0.21"
    "2" = "10.240.0.22"
    }
}

resource "google_compute_instance" "worker" {
  count = 3
  name = "worker${count.index}"
  machine_type = "n1-standard-1"
  zone = "us-central1-a"

  disk {
    image = "ubuntu-os-cloud/ubuntu-1604-xenial-v20160921"
    size = "200"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kubernetes.name}"
    address = "${lookup(var.worker_ips, count.index)}"
    access_config {
    }
  }

  can_ip_forward = true
}
