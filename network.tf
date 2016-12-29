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
