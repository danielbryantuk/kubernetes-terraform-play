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

  provisioner "remote-exec" {
       inline = [
       "echo 'As soon as remote-exec succeeds we know that the instance is accepting ssh connections'"
       ]
       connection {
        type = "ssh"
        user = "danielbryant"
        private_key = "${file("/Users/danielbryant/.ssh/gcloud-id-2")}"
      }
   }
}
