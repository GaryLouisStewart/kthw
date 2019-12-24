resource "aws_instance" "kubernetes_master" {
    count                       = "${var.node_count["master"]}"
    ami                         = "${var.kube_amis["master"]}"
    key_name                    = "${var.aws_keypair_name["master"]}"
    instance_type               = "${var.kube_node_type["master"]}"
    subnet_id                   = "${element(aws_subnet.kube_master_subnet.*.id, count.index)}"
    security_groups             = ["${aws_security_group.kubernetes_masters.name}"]
    associate_public_ip_address = "${var.associate_pub_ip_master}"
    vpc_security_group_ids      = ["${aws_security_group.kubernetes_masters.id}"]
    tags = "${merge(map(
        "Name", "Kubernetes Master Node-${count.index}",
        "kubernetes.io/cluster/${var.cluster_name}", "shared"
        ), var.common_tags)}"
}

resource "aws_instance" "kubernetes_node" {
    count                       = "${var.node_count["worker"]}"
    ami                         = "${var.kube_amis["worker"]}"
    key_name                    = "${var.aws_keypair_name["worker"]}"
    instance_type               = "${var.kube_node_type["worker"]}"
    subnet_id                   = "${element(aws_subnet.kube_worker_subnet.*.id, count.index)}"
    security_groups             = ["${aws_security_group.kubernetes_workers.name}"]
    associate_public_ip_address = "${var.associate_pub_ip_worker}"
    vpc_security_group_ids      = ["${aws_security_group.kubernetes_workers.id}"]
    tags = "${merge(map(
        "Name", "Kubernetes Worker Node-${count.index}",
        "kubernetes.io/cluster/${var.cluster_name}", "shared"
        ), var.common_tags)}"
}
