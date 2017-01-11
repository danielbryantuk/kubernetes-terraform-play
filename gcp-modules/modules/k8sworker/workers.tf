resource "google_compute_instance" "worker" {
  count = "${length(var.worker_ips)}"
  name = "worker${count.index}"
  machine_type = "${var.worker_machine_type}"
  zone = "${var.worker_zone}"

  tags = ["worker"]

  disk {
    image = "${var.worker_disk_image}"
    size = "${var.worker_disk_size}"
  }

  network_interface {
    subnetwork = "${var.k8s_subnet_name}"
    address = "${lookup(var.worker_ips, count.index)}"
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
        private_key = "${file(var.instance_private_key)}"
      }
   }
}
