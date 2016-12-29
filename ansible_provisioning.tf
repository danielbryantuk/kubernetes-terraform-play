resource "null_resource" "ansible-provision" {
  depends_on = ["null_resource.certificates"]
  provisioner "local-exec" {
    command = "echo '[kube-controllers]\n' > ansible/inventory/hosts"
  }

  provisioner "local-exec" {
    command = "echo \"${join("\n", formatlist("%s ansible_ssh_host=%s", google_compute_instance.controller.*.name, google_compute_instance.controller.*.network_interface.0.access_config.0.assigned_nat_ip))}\" >> ansible/inventory/hosts"
  }

  provisioner "local-exec" {
    command = "echo '\n[kube-workers]\n' >> ansible/inventory/hosts"
  }

  provisioner "local-exec" {
    command = "echo \"${join("\n", formatlist("%s ansible_ssh_host=%s", google_compute_instance.worker.*.name, google_compute_instance.worker.*.network_interface.0.access_config.0.assigned_nat_ip))}\" >> ansible/inventory/hosts"
  }

  provisioner "local-exec" {
    command = "cd ansible; ansible-playbook -i inventory/hosts -u danielbryant --private-key /Users/danielbryant/.ssh/gcloud-id-2 bootstrap.yaml"
  }
}
