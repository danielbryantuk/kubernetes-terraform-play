resource "google_compute_network" "kubernetes" {
  name = "${var.network_name}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "kubernetes" {
  name = "${var.network_name}"
  ip_cidr_range = "${var.k8s_subnet_ip_cidr_range}"
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

  source_ranges = ["${var.k8s_subnet_ip_cidr_range}"]
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

resource "google_compute_http_health_check" "kubernetes-health" {
  name = "kubernetes-health"
  description = "Kubernetes API Server Health Check"
  request_path = "/healthz"
  port = "8080"
}

resource "google_compute_target_pool" "kubernetes-pool" {
  name = "kubernetes-pool"

  instances = ["${var.k8s-controller-links}"]

  health_checks = [
    "${google_compute_http_health_check.kubernetes-health.name}"
  ]
}

resource "google_compute_forwarding_rule" "kubernetes-rule" {
  name = "kubernetes-rule"
  target = "${google_compute_target_pool.kubernetes-pool.self_link}"
  port_range = "6443-6443"
  ip_address = "${google_compute_address.kubernetes.address}"
}

/*resource "google_compute_route" "k8s-route-1" {
  name = "k8s-route-1"
  network = "${google_compute_network.kubernetes.name}"
  dest_range = "10.240.0.0/24"

  next_hop_ip = "${google_compute_instance.worker.0.network_interface.0.access_config.0.assigned_nat_ip}"
  priority = 1000
}

resource "google_compute_route" "k8s-route-2" {
  name = "k8s-route-2"
  network = "${google_compute_network.kubernetes.name}"
  dest_range = "10.240.1.0/24"
  next_hop_ip = "${google_compute_instance.worker.1.network_interface.0.access_config.0.assigned_nat_ip}"
  priority = 1000
}

resource "google_compute_route" "k8s-route-3" {
  name = "k8s-route-3"
  network = "${google_compute_network.kubernetes.name}"
  dest_range = "10.240.2.0/24"
  next_hop_ip = "${google_compute_instance.worker.2.network_interface.0.access_config.0.assigned_nat_ip}"
  priority = 1000
}*/
