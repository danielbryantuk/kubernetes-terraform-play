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



resource "google_compute_instance" "controller0" {
  name = "controller0"
  machine_type = "n1-standard-1"
  zone = "us-central1-a"

  disk {
    image = "ubuntu-os-cloud/ubuntu-1604-xenial-v20160921"
    size = "200"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kubernetes.name}"
    address = "10.240.0.10"
    access_config {
    }
  }

  can_ip_forward = true
}

resource "google_compute_instance" "controller1" {
  name = "controller1"
  machine_type = "n1-standard-1"
  zone = "us-central1-a"

  disk {
    image = "ubuntu-os-cloud/ubuntu-1604-xenial-v20160921"
    size = "200"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kubernetes.name}"
    address = "10.240.0.11"
    access_config {
    }
  }

  can_ip_forward = true
}

resource "google_compute_instance" "controller2" {
  name = "controller2"
  machine_type = "n1-standard-1"
  zone = "us-central1-a"

  disk {
    image = "ubuntu-os-cloud/ubuntu-1604-xenial-v20160921"
    size = "200"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kubernetes.name}"
    address = "10.240.0.12"
    access_config {
    }
  }

  can_ip_forward = true
}

resource "google_compute_instance" "worker0" {
  name = "worker0"
  machine_type = "n1-standard-1"
  zone = "us-central1-a"

  disk {
    image = "ubuntu-os-cloud/ubuntu-1604-xenial-v20160921"
    size = "200"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kubernetes.name}"
    address = "10.240.0.20"
    access_config {
    }
  }

  can_ip_forward = true
}

resource "google_compute_instance" "worker1" {
  name = "worker1"
  machine_type = "n1-standard-1"
  zone = "us-central1-a"

  disk {
    image = "ubuntu-os-cloud/ubuntu-1604-xenial-v20160921"
    size = "200"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kubernetes.name}"
    address = "10.240.0.21"
    access_config {
    }
  }

  can_ip_forward = true
}

resource "google_compute_instance" "worker2" {
  name = "worker2"
  machine_type = "n1-standard-1"
  zone = "us-central1-a"

  disk {
    image = "ubuntu-os-cloud/ubuntu-1604-xenial-v20160921"
    size = "200"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kubernetes.name}"
    address = "10.240.0.22"
    access_config {
    }
  }

  can_ip_forward = true
}
