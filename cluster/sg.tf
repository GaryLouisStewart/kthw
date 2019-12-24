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

resource "aws_security_group_rule" "kubernetes_masters" {
  count             = "${var.kubemaster_secure_ingress ? length(var.kubemaster_ingress_ports)  :0}"
  cidr_blocks       = ["${length(var.kubemaster_cidr_ingress_access)}"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = "${element(var.kubemaster_ingress_ports, count.index)}"
  protocol          = "tcp"
  security_group_id = "${aws_security_group.kubernetes_masters.id}"
  to_port           = "${element(var.kubemaster_ingress_ports, count.index)}"
  type              = "ingress"
}
