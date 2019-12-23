resource "aws_vpc" "kthw_vpc" {
    cidr_block             = "${var.vpc_vars["cidr_block"]}"
    enable_dns_support     = "${var.vpc_vars["enable_dns_support"]}"
    enable_dns_hostnames   = "${var.vpc_vars["enable_dns_hostnames"]}"
    enable_classiclink     = "${var.vpc_vars["enable_classiclink"]}"
    instance_tenancy       = "${var.vpc_vars["instance_tenancy"]}"
    tags = "${merge(map(
        "Name", "Kubernetes the hard way"
    ), var.common_tags)}"
}

resource "aws_vpc_endpoint" "ec2" {
  count = "${var.create_vpc_endpoint ? 1 : 0}"
  vpc_id            = "${aws_vpc.kthw_vpc.id}"
  service_name      = "${var.vpc_endpoint_ec2["service_name"]}"
  vpc_endpoint_type = "${var.vpc_endpoint_ec2["endpoint_type"]}"

  security_group_ids = [
    "${aws_security_group.bastion-inbp.id}",
  ]

  private_dns_enabled = "${var.vpc_endpoint_ec2["private_dns"]}"
}

resource "aws_instance" "bastion" {
    ami                         = "${var.bastion_ami_name}"
    key_name                    = "${var.bastion_ssh_keypair}"
    instance_type               = "${var.aws_instance_type}"
    security_groups             = ["${aws_security_group.bastion-inbp.name}"]
    associate_public_ip_address = "${var.associate_bastion_public_ip}"
    vpc_security_group_ids      = ["${aws_security_group.bastion-inbp.id}"]
    tags = "${merge(map(
        "Name", "Bastion host")
        , var.common_tags)}"
}

resource "aws_security_group" "bastion-inbp" {
    name = "bastion-security-group"
    vpc_id = "${aws_vpc.kthw_vpc.id}"

    egress {
        protocol    = -1
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group_rule" "bastion-inbp-secure" {
  count             = "${var.create_bastion_secure ? 1 : 0}"
  cidr_blocks       = "${var.cidr_block_bastion}"
  description       = "Allow traffic into the bastion instance from a secure source e.g. VPN server"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.bastion-inbp.id}"
  to_port           = 22
  type              = "ingress"
}

#################################################
# Allows access in from workstation insecurely ##
#################################################

resource "aws_security_group_rule" "bastion-inbp-insecure" {
  count             = "${var.create_bastion_insecure ? 1 : 0}"
  cidr_blocks       = ["${chomp(data.http.myipaddr.body)}/32"]
  description       = "Allow traffic into bastion instance from our workstation"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.bastion-inbp.id}"
  to_port           = 22
  type              = "ingress"
}
