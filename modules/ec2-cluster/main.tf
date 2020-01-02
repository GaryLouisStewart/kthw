resource "aws_vpc" "kubernetes_vpc" {
    cidr_block             = "${var.vpc_vars["cidr_block"]}"
    enable_dns_support     = "${var.vpc_vars["enable_dns_support"]}"
    enable_dns_hostnames   = "${var.vpc_vars["enable_dns_hostnames"]}"
    enable_classiclink     = "${var.vpc_vars["enable_classiclink"]}"
    instance_tenancy       = "${var.vpc_vars["instance_tenancy"]}"
    tags = "${merge(map(
        "Name", "Kubernetes cluster",
        "kubernetes.io/cluster/${var.cluster_name}", "shared"
    ), var.common_tags)}"
}


resource "aws_instance" "kubernetes_master" {
    count                       = "${var.master_node_count}"
    ami                         = "${var.ami_master_node}"
    key_name                    = "${var.ssh_keypair_master}"
    instance_type               = "${var.type_master_node}"
    subnet_id                   = "${element(aws_subnet.kube_master_subnet.*.id, count.index)}"
    vpc_security_group_ids      = ["${aws_security_group.kubernetes_masters.id}"]
    tags = "${merge(map(
        "Name", "Kubernetes Master Node-${count.index}",
        "kubernetes.io/cluster/${var.cluster_name}", "shared"
        ), var.common_tags)}"
}

resource "aws_instance" "kubernetes_node" {
    count                       = "${var.worker_node_count}"
    ami                         = "${var.ami_worker_node}"
    key_name                    = "${var.ssh_keypair_worker}"
    instance_type               = "${var.type_worker_node}"
    subnet_id                   = "${element(aws_subnet.kube_worker_subnet.*.id, count.index)}"
    vpc_security_group_ids      = ["${aws_security_group.kubernetes_workers.id}"]
    tags = "${merge(map(
        "Name", "Kubernetes Worker Node-${count.index}",
        "kubernetes.io/cluster/${var.cluster_name}", "shared"
        ), var.common_tags)}"
}

resource "aws_subnet" "kube_master_subnet" {
    count               = "${length(var.subnet_kube_masters)}"
    availability_zone   = "${data.aws_availability_zones.available.names[count.index]}"
    cidr_block          = "${element(var.subnet_kube_masters, count.index)}"
    vpc_id              = "${aws_vpc.kubernetes_vpc.id}"
    tags = "${merge(map(
        "Name", "Kubernetes Master Nodes",
        "kubernetes.io/cluster/${var.cluster_name}", "shared"
    ), var.common_tags)}"
}

resource "aws_subnet" "kube_worker_subnet" {
    count               = "${length(var.subnet_kube_workers)}"
    availability_zone   = "${data.aws_availability_zones.available.names[count.index]}"
    cidr_block          = "${element(var.subnet_kube_workers, count.index)}"
    vpc_id              = "${aws_vpc.kubernetes_vpc.id}"
    tags = "${merge(map(
        "Name", "Kubernetes Worker Nodes",
        "kubernetes.io/cluster/${var.cluster_name}", "shared"
    ), var.common_tags)}"
}

#### Kubernetes master node sg ####
# allow communication to master ###
###################################

resource "aws_security_group" "kubernetes_masters" {
  name        = "kthw master nodes"
  description = "Kubernetes API server communication (Master nodes)"
  vpc_id      = "${aws_vpc.kubernetes_vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(map(
      "Name", "Kubernetes Master node",
      "kubernetes.io/cluster/${var.cluster_name}", "shared"
  ), var.common_tags)}"
}

#### Kubernetes worker node sg ####
# allow communication to worker ###
###################################

resource "aws_security_group" "kubernetes_workers" {
  name        = "kthw worker nodes"
  description = "Kubernetes worker communication (worker nodes)"
  vpc_id      = "${aws_vpc.kubernetes_vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(map(
      "Name", "Kubernetes worker node",
      "kubernetes.io/cluster/${var.cluster_name}", "shared"
  ), var.common_tags)}"
}

#### Kubernetes security group rules ####
#########################################

## masters
resource "aws_security_group_rule" "kube_master_secure" {
  count             = "${var.secure_ingress_kubernetes_masters ? length(var.ingress_ports_kubernetes_masters) :0}"
  cidr_blocks       = ["${element(var.kubernetes_masters_ingress_cidr_range, count.index)}"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = "${element(var.ingress_ports_kubernetes_masters, count.index)}"
  protocol          = "tcp"
  security_group_id = "${aws_security_group.kubernetes_masters.id}"
  to_port           = "${element(var.ingress_ports_kubernetes_masters, count.index)}"
  type              = "ingress"
}

resource "aws_security_group_rule" "kube_master_insecure" {
  count             = "${var.insecure_ingress_kubernetes_masters ? length(var.ingress_ports_kubernetes_masters) :0}"
  cidr_blocks       = ["${chomp(data.http.myipaddr.body)}/32"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = "${element(var.ingress_ports_kubernetes_masters, count.index)}"
  protocol          = "tcp"
  security_group_id = "${aws_security_group.kubernetes_masters.id}"
  to_port           = "${element(var.ingress_ports_kubernetes_masters, count.index)}"
  type              = "ingress"
}

## workers

resource "aws_security_group_rule" "kube_node_ingress_self" {
    description              = "Allow nodes to communicate with each other"
    from_port                = 0
    protocol                 = "-1"
    security_group_id        = "${aws_security_group.kubernetes_workers.id}"
    source_security_group_id = "${aws_security_group.kubernetes_workers.id}"
    to_port                  = 65535
    type                     = "ingress"
}

resource "aws_security_group_rule" "kube_node_ingress_cluster"{
    description              = "Allow worker kubelets and pods to receive comms from cluster control pane"
    from_port                = 1025
    protocol                 = "tcp"
    security_group_id        = "${aws_security_group.kubernetes_workers.id}"
    source_security_group_id = "${aws_security_group.kubernetes_workers.id}"
    to_port                  = 65535
    type                     = "ingress"
}


## node to master access

resource "aws_security_group_rule" "kube_node_cluster_ingress_node_https" {
    description              = "Allow pods to communicate with the cluster API server"
    from_port                = 443
    protocol                 = "tcp"
    security_group_id        = "${aws_security_group.kubernetes_masters.id}"
    source_security_group_id = "${aws_security_group.kubernetes_workers.id}"
    to_port                  = 443
    type                     = "ingress"
}

data "http" "myipaddr" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_availability_zones" "available" {}
