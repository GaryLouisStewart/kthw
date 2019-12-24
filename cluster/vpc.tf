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
