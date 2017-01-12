data "template_file" "certificates" {
  template = "${file("../terraform-templates/kubernetes-csr.json.tpl")}" #todo fix paths in this file
  vars { # todo make this dynamic
    controller0_ip = "${element(module.kubecontroller.k8s-controllers-network,0)}"
    controller1_ip = "${element(module.kubecontroller.k8s-controllers-network,1)}"
    controller2_ip = "${element(module.kubecontroller.k8s-controllers-network,2)}"
    worker0_ip = "${element(module.kubeworker.k8s-workers-network,0)}"
    worker1_ip = "${element(module.kubeworker.k8s-workers-network,1)}"
    worker2_ip = "${element(module.kubeworker.k8s-workers-network,2)}"
    kubernetes_public_address = "${module.staging.k8s-network-address}"
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
