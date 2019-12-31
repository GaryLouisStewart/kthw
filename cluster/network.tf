resource "aws_subnet" "kube_master_subnet" {
    count               = 2
    availability_zone   = "${data.aws_availability_zones.available.names[count.index]}"
    cidr_block          = "${element(var.kube_master_subnet, count.index)}"
    vpc_id              = "${aws_vpc.kubernetes_vpc.id}"
    tags = "${merge(map(
        "Name", "Kubernetes Master Nodes",
        "kubernetes.io/cluster/${var.cluster_name}", "shared"
    ), var.common_tags)}"
}

resource "aws_subnet" "kube_worker_subnet" {
    count               = 2
    availability_zone   = "${data.aws_availability_zones.available.names[count.index]}"
    cidr_block          = "${element(var.kube_worker_subnet, count.index)}"
    vpc_id              = "${aws_vpc.kubernetes_vpc.id}"
    tags = "${merge(map(
        "Name", "Kubernetes Worker Nodes",
        "kubernetes.io/cluster/${var.cluster_name}", "shared"
    ), var.common_tags)}"
}
