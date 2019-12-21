resource "aws_vpc" "bastion_vpc" {
    cidr_block = "${var.vpc_vars["cidr_block"]}"
    enable_dns_support = "${var.vpc_vars["enable_dns_support"]}"
    enable_dns_hostnames = "${var.vpc_vars["enable_dns_hostnames"]}"
    enable_classiclink = "${var.vpc_vars["enable_classiclink"]}"
    instance_tenancy = "${var.vpc_vars["instance_tenancy"]}"
    tags = "${merge(map(
        "Name", "Bastion-INBP"
    ), var.common_tags)}"
}
