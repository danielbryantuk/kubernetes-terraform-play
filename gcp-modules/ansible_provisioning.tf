resource "null_resource" "ansible-provision" {
  depends_on = ["module.staging"]
  provisioner "local-exec" {
    command = "echo '[kube-controllers]\n' > inventory/hosts"
  }

  provisioner "local-exec" {
    command = "echo \"${join("\n", formatlist("%s ansible_ssh_host=%s", module.kubecontroller.k8s-controllers, module.kubecontroller.k8s-controllers-network))}\" >> inventory/hosts"
  }

  provisioner "local-exec" {
    command = "echo '\n[kube-workers]\n' >> inventory/hosts"
  }

  provisioner "local-exec" {
    command = "echo \"${join("\n", formatlist("%s ansible_ssh_host=%s", module.kubeworker.k8s-workers, module.kubeworker.k8s-workers-network))}\" >> inventory/hosts"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory/hosts -u ${var.instance_ssh_username} --private-key ${var.instance_private_key} ../ansible/site.yaml"
  }
}
