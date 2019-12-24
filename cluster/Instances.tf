resource "aws_instance" "kubernetes_master" {
    count                       = "${var.node_count["master"]}"
    ami                         = "${var.kube_amis["master"]}"
    key_name                    = "${var.aws_keypair_name}"
    instance_type               = "${var.kube_node_types["master"]}"
    security_groups             = ["${aws_security_group.kubernetes_masters.name}"]
    associate_public_ip_address = "${var.associate_pub_ip_master}"
    vpc_security_group_ids      = ["${aws_security_group.kubernetes_masters.id}"]
    tags = "${merge(map(
        "Name", "Kubernetes Master Node-${count.index}",
        "kubernetes.io/cluster/${var.cluster_name}", "shared"
        ), var.common_tags)}"
}
