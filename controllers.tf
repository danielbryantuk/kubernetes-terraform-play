resource "google_compute_instance" "controller" {
  count = "${length(var.controller_ips)}"
  name = "controller${count.index}"
  machine_type = "${var.machine_type}"
  zone = "${var.zone}"

  disk {
    image = "${var.disk_image}"
    size = "${var.disk_size}"
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
       "echo 'Use remote-exec to ensure that instance is ready and accepting ssh connections'"
       ]
       connection {
        type = "ssh"
        user = "${var.instance_ssh_username}"
        private_key = "${var.instance_private_key}"
      }
   }
}
