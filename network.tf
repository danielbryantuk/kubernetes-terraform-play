resource "google_compute_network" "kubernetes" {
  name = "${var.network_name}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "kubernetes" {
  name = "${var.network_name}"
  ip_cidr_range = "10.240.0.0/24"
  network = "${google_compute_network.kubernetes.self_link}"
}

resource "google_compute_firewall" "kubernetes-allow-icmp" {
  name = "${var.network_name}-allow-icmp"
  network = "${google_compute_network.kubernetes.name}"

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "kubernetes-allow-internal" {
  name = "${var.network_name}-allow-internal"
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
  name = "${var.network_name}-allow-rdp"
  network = "${google_compute_network.kubernetes.name}"

  allow {
    protocol = "tcp"
    ports = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "kubernetes-allow-ssh" {
  name = "${var.network_name}-allow-ssh"
  network = "${google_compute_network.kubernetes.name}"

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "kubernetes-allow-healthz" {
  name = "${var.network_name}-allow-health"
  network = "${google_compute_network.kubernetes.name}"

  allow {
    protocol = "tcp"
    ports = ["8080"]
  }

  source_ranges = ["130.211.0.0/22"]
}

resource "google_compute_firewall" "kubernetes-allow-api-server" {
  name = "${var.network_name}-allow-api-server"
  network = "${google_compute_network.kubernetes.name}"

  allow {
    protocol = "tcp"
    ports = ["6443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "kubernetes" {
  name = "${var.network_name}"
}
