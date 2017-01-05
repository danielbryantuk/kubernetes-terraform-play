resource "aws_vpc" "kubernetes" {
  cidr_block = "10.240.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "kubernetes"
  }
}

resource "aws_vpc_dhcp_options" "kubernetes" {
  domain_name = "eu-west-1.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags {
    Name = "kubernetes"
  }
}

resource "aws_vpc_dhcp_options_association" "dns" {
  vpc_id = "${aws_vpc.kubernetes.id}"
  dhcp_options_id = "$aws_vpc_dhcp_options.kubernetes.id"
}

resource "aws_subnet" "kubernetes" {
  vpc_id = "${aws_vpc.kubernetes.id}"
  cidr_block = "10.240.0.0/24"

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
