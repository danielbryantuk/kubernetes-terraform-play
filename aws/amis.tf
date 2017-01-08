data "aws_ami" "k8s_base_image" {
  most_recent = true
  filter {
    name = "name"
    values = ["${var.instance_image}"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["${var.instance_image_provider_id}"]
}
