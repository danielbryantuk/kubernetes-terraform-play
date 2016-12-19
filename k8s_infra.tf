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

data "template_file" "certificates" {
  template = "${file("template/kubernetes-csr.json.j2")}"
  vars {
    controller0_ip = "${google_compute_instance.controller.0.network_interface.0.address}"
    controller1_ip = "${google_compute_instance.controller.1.network_interface.0.address}"
    controller2_ip = "${google_compute_instance.controller.2.network_interface.0.address}"
    worker0_ip = "${google_compute_instance.worker.0.network_interface.0.address}"
    worker1_ip = "${google_compute_instance.worker.1.network_interface.0.address}"
    worker2_ip = "${google_compute_instance.worker.2.network_interface.0.address}"
    kubernetes_public_address = "${google_compute_address.kubernetes.address}"
  }
}

resource "null_resource" "certificates" {
  triggers {
    template_rendered = "${data.template_file.certificates.rendered}"
  }
  provisioner "local-exec" {
    command = "echo '${data.template_file.certificates.rendered}' > cert-authority/kubernetes-csr.json"
  }
  provisioner "local-exec" {
    command = "cd cert-authority; cfssl gencert -initca ca-csr.json | cfssljson -bare ca; cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes"
  }
}
