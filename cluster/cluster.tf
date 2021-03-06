module "kubernetes_bastion_hosts" {
    source                        = "../modules/bastion-host"
    bastion_ami                   = "${var.ami_master_node}"
    target_vpc_id                 = "${module.ec2-cluster.vpc_id}"
    target_security_group_id      = "${module.ec2-cluster.security_group_id}"
    common_tags                   = "${var.common_tags}"
    bastion_ssh_ingress           = "${var.kubernetes_masters_ingress_cidr_range}"
    bastion_subnets               = ["10.0.5.0/24", "10.0.6.0/24"]
    cidr_range_bastion_access     = ["0.0.0.0/0"]
    ssh_keypair                   = "master-nodes"
}

module "ec2-cluster" {
    source                                  = "../modules/ec2-cluster"
    ami_worker_node                         = "${var.ami_worker_node}"
    ami_master_node                         = "${var.ami_master_node}"
    type_worker_node                        = "${var.type_worker_node}"
    type_master_node                        = "${var.type_master_node}"
    ssh_keypair_worker                      = "${var.ssh_keypair_worker}"
    ssh_keypair_master                      = "${var.ssh_keypair_master}"
    master_node_count                       = "${var.master_node_count}"
    worker_node_count                       = "${var.worker_node_count}"
    common_tags                             = "${var.common_tags}"
    vpc_vars                                = "${var.vpc_vars}"
    subnet_kube_masters                     = "${var.subnet_kube_masters}"
    subnet_kube_workers                     = "${var.subnet_kube_workers}"
    cluster_name                            = "${var.cluster_name}"
    kubernetes_masters_ingress_cidr_range   = "${var.kubernetes_masters_ingress_cidr_range}"
    ingress_ports_kubernetes_masters        = "${var.ingress_ports_kubernetes_masters}"
}
