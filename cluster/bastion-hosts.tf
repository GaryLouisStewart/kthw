module "kubernetes_bastion_hosts" {
    source                        = "../modules/bastion-host"
    bastion_ami                   = "${var.kube_amis["master"]}"
    target_vpc_id                 = "${aws_vpc.kubernetes_vpc.id}"
    target_security_group_id      = "${aws_security_group.kubernetes_masters.id}"
    common_tags                   = "${var.common_tags}"
    bastion_ssh_ingress           = "${var.kubemaster_cidr_ingress_access}"
    bastion_subnets               = ["10.0.5.0/24", "10.0.6.0/24"]
    cidr_range_bastion_access     = ["0.0.0.0/0"]
    ssh_keypair                   = "master-nodes"
}