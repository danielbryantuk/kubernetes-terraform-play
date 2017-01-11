resource "null_resource" "ansible-provision" {
  depends_on = ["module.staging"]
  provisioner "local-exec" {
    command = "echo '[kube-controllers]\n' > inventory/hosts"
  }

  provisioner "local-exec" {
    command = "echo \"${join("\n", formatlist("%s ansible_ssh_host=%s", module.k8scontroller.google_compute_instance.controller.*.name, module.k8scontroller.google_compute_instance.controller.*.network_interface.0.access_config.0.assigned_nat_ip))}\" >> inventory/hosts"
  }

  provisioner "local-exec" {
    command = "echo '\n[kube-workers]\n' >> inventory/hosts"
  }

  provisioner "local-exec" {
    command = "echo \"${join("\n", formatlist("%s ansible_ssh_host=%s", module.k8sworker.google_compute_instance.worker.*.name, module.k8sworker.google_compute_instance.worker.*.network_interface.0.access_config.0.assigned_nat_ip))}\" >> inventory/hosts"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory/hosts -u ${var.instance_ssh_username} --private-key ${var.instance_private_key} ../ansible/site.yaml"
  }
}
