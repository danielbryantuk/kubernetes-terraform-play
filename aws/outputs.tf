output "controller_public_ips" {
  value = "${join(", ", aws_instance.controller.*.public_ip)}"
}

output "controller_0_ssh" {
  value = "ssh -i ~/.ssh/gcloud-id-2 ubuntu@${aws_instance.controller.0.public_ip}"
}

output "worker_public_ips" {
  value = "${join(", ", aws_instance.worker.*.public_ip)}"
}
