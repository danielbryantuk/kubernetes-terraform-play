variable "controller_ips" {
  default = {
    "0" = "10.240.0.10"
    "1" = "10.240.0.11"
    "2" = "10.240.0.12"
    }
}

resource "aws_instance" "controller" {
  count = "3"
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.small"

  iam_instance_profile = "${aws_iam_instance_profile.kubernetes.id}"
  key_name = "${aws_key_pair.kubernetes.key_name}"

  vpc_security_group_ids = ["${aws_security_group.kubernetes.id}"]
  subnet_id = "${aws_subnet.kubernetes.id}"
  source_dest_check = false

  associate_public_ip_address = true
  private_ip = "${lookup(var.controller_ips, count.index)}"

  tags {
    Name = "controller${count.index}"
    Ansible_host_group = "controller"
  }

  provisioner "remote-exec" {
       inline = [
       "echo 'Use remote-exec to ensure that instance is ready and accepting ssh connections'"
       ]
       connection {
        type = "ssh"
        user = "${var.instance_ssh_username}"
        private_key = "${file(var.instance_private_key_file)}"
      }
   }
}
