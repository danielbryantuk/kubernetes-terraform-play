resource "null_resource" "ansible-provision" {
  depends_on = ["null_resource.certificates"]

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory -u ${var.instance_ssh_username} --private-key ${var.instance_private_key_file} ${var.ansible_playbook_file_location}"
  }
}
