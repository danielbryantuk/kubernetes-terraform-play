resource "aws_vpc" "kubernetes" {
  cidr_block = "${var.k8s_vpc_cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "kubernetes"
  }
}

resource "aws_vpc_dhcp_options" "kubernetes" {
  domain_name = "${var.dhcp_domain_name}"
  domain_name_servers = "${var.dhcp_domain_name_servers}"

  tags {
    Name = "kubernetes"
  }
}

resource "aws_vpc_dhcp_options_association" "kubernetes" {
  vpc_id = "${aws_vpc.kubernetes.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.kubernetes.id}"
}

resource "aws_subnet" "kubernetes" {
  vpc_id = "${aws_vpc.kubernetes.id}"
  cidr_block = "${var.k8s_vpc_subnet}"

  tags {
    Name = "kubernetes"
  }
}

resource "aws_internet_gateway" "kubernetes" {
  vpc_id = "${aws_vpc.kubernetes.id}"

  tags {
    Name = "kubernetes"
  }
}

resource "aws_route_table" "kubernetes" {
  vpc_id = "${aws_vpc.kubernetes.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.kubernetes.id}"
  }

  tags {
    Name = "kubernetes"
  }
}

resource "aws_route_table_association" "kubernetes" {
  subnet_id = "${aws_subnet.kubernetes.id}"
  route_table_id = "${aws_route_table.kubernetes.id}"
}

resource "aws_security_group" "kubernetes" {
  description = "Kubernetes security group"
  vpc_id = "${aws_vpc.kubernetes.id}"

/*
Kelsey also has a generic ingress rules in his tutorial, which I'm not
sure I can recreate here (or is it implict/default it's for all ports
and a cidr_block of 0.0.0.0/0?) <- this appears plausible! TODO!!

aws ec2 authorize-security-group-ingress \
  --group-id ${SECURITY_GROUP_ID} \
  --protocol all

https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/01-infrastructure-aws.md
*/

  egress {
    protocol = "-1"
    from_port = "0"
    to_port = "0"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol = "-1"
    from_port = "0"
    to_port = "0"
    cidr_blocks = ["${var.k8s_vpc_cidr}"]
  }

  ingress {
    protocol = "tcp"
    from_port = "22"
    to_port = "22"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol = "tcp"
    from_port = "6443"
    to_port = "6443"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol = "-1"
    from_port = "0"
    to_port = "0"
    self = true
  }

  tags {
    Name = "kubernetes"
  }
}

resource "aws_elb" "kubernetes" {
  name = "kubernetes"

  listener {
    instance_port = "6443"
    instance_protocol = "TCP"
    lb_port = "6443"
    lb_protocol = "TCP"
  }

  subnets = ["${aws_subnet.kubernetes.id}"]
  security_groups = ["${aws_security_group.kubernetes.id}"]
}
