data "template_file" "certificates" {
  template = "${file("../terraform-templates/kubernetes-csr.json.tpl")}"
  vars {
    controller0_ip = "${aws_instance.controller.0.public_ip}"
    controller1_ip = "${aws_instance.controller.1.public_ip}"
    controller2_ip = "${aws_instance.controller.0.public_ip}"
    worker0_ip = "${aws_instance.worker.0.public_ip}"
    worker1_ip = "${aws_instance.worker.1.public_ip}"
    worker2_ip = "${aws_instance.worker.2.public_ip}"
    kubernetes_public_address = "${aws_elb.kubernetes.dns_name}"
  }
}

resource "null_resource" "certificates" {
  triggers {
    template_rendered = "${data.template_file.certificates.rendered}"
  }
  provisioner "local-exec" {
    command = "mkdir cert-authority; echo '${data.template_file.certificates.rendered}' > cert-authority/kubernetes-csr.json"
  }
  provisioner "local-exec" {
    command = "cd cert-authority; cfssl gencert -initca ../../terraform-templates/ca-csr.json | cfssljson -bare ca; cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=../../terraform-templates/ca-config.json -profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes"
  }
}
