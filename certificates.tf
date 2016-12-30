data "template_file" "certificates" {
  template = "${file("template/kubernetes-csr.json.tpl")}"
  vars {
    controller0_ip = "${google_compute_instance.controller.0.network_interface.0.address}"
    controller1_ip = "${google_compute_instance.controller.1.network_interface.0.address}"
    controller2_ip = "${google_compute_instance.controller.2.network_interface.0.address}"
    worker0_ip = "${google_compute_instance.worker.0.network_interface.0.address}"
    worker1_ip = "${google_compute_instance.worker.1.network_interface.0.address}"
    worker2_ip = "${google_compute_instance.worker.2.network_interface.0.address}"
    kubernetes_public_address = "${google_compute_address.kubernetes.address}"
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
    command = "cd cert-authority; cfssl gencert -initca ../template/ca-csr.json | cfssljson -bare ca; cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=../template/ca-config.json -profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes"
  }
}
