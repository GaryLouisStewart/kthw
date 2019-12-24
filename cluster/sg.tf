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
  count             = "${var.kubemaster_secure_ingress ? length(var.kubemaster_ingress_ports)  :0}"
  cidr_blocks       = ["${length(var.kubemaster_cidr_ingress_access)}"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = "${element(var.kubemaster_ingress_ports, count.index)}"
  protocol          = "tcp"
  security_group_id = "${aws_security_group.kubernetes_masters.id}"
  to_port           = "${element(var.kubemaster_ingress_ports, count.index)}"
  type              = "ingress"
}

resource "aws_security_group_rule" "kube_master_insecure" {
  count             = "${var.kubemaster_insecure_ingress ? length(var.kubemaster_ingress_ports)  :0}"
  cidr_blocks       = ["${chomp(data.http.myipaddr.body)}/32"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = "${element(var.kubemaster_ingress_ports, count.index)}"
  protocol          = "tcp"
  security_group_id = "${aws_security_group.kubernetes_masters.id}"
  to_port           = "${element(var.kubemaster_ingress_ports, count.index)}"
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
