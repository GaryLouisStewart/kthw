# aws instances
resource "aws_instance"  "bastion-instance" {
    count                   = "${var.bastion_count}"
    ami                     = "${var.bastion_ami}"
    key_name                = "${var.ssh_keypair}"
    instance_type           = "${var.instance_type}"
    vpc_security_group_ids  = ["${aws_security_group.bastion-ssh.id}"]
    tags = "${merge(map(
        "Name", "Bastion host"
    ), var.common_tags)}"

}


resource "aws_internet_gateway" "bastion" {
    vpc_id = "${var.target_vpc_id}"
}

# subnets & security groups

# subnets

resource "aws_subnet" "bastion-public-subnet"{
    count                   = "${length(var.bastion_subnets)}"
    availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
    cidr_block              = "${element(var.bastion_subnets, count.index)}"
    vpc_id                  = "${var.target_vpc_id}"
    map_public_ip_on_launch =  true
}


# security group

resource "aws_security_group" "bastion-ssh" {
    name                = "bastion-host-security-group"
    description         = "A security group for the bastion host servers"
    vpc_id              = "${var.target_vpc_id}"

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = "${merge(map(
        "Name", "bastion host security group",
    ), var.common_tags)}"
}


# security group rules

resource "aws_security_group_rule" "bastion-ssh" {
    count                       =  "${length(var.bastion_ssh_ingress)}"
    cidr_blocks                 = ["${element(var.bastion_ssh_ingress, count.index)}"]
    description                 = "Allow ssh ingress into bastion host nodes"
    from_port                   = "443"
    protocol                    = "tcp"
    security_group_id           = "${aws_security_group.bastion-ssh.id}"
    to_port                     = "443"
    type                        = "ingress" 
}

resource "aws_security_group_rule" "bastion-to-kubernetes-workers" {
    count                       = "${length(var.bastion_subnets)}"
    cidr_blocks                 = ["${element(var.bastion_subnets, count.index)}"]
    description                 = "Allow nodes to connect to private subnets"
    from_port                   = "443"
    protocol                    = "tcp"
    security_group_id           = "${var.target_security_group_id}"
    to_port                     = "443"
    type                        = "ingress"
}


resource "aws_route_table" "bastion-hosts" {
    vpc_id                      = "${var.target_vpc_id}"

    route {
        cidr_block              = "10.0.0.0/16"
        gateway_id              = "${aws_internet_gateway.bastion.id}"
    }

}

resource "aws_route" "bastion-administration" {
    count                       = "${length(var.cidr_range_bastion_access)}"
    route_table_id              = "${aws_route_table.bastion-hosts.id}"
    destination_cidr_block      = "${element(var.cidr_range_bastion_access, count.index)}"
    depends_on                  = ["aws_route_table.bastion-hosts"]
}


# data sources


data "http" "myipaddr" {
  url = "http://ipv4.icanhazip.com"
}

data  "aws_availability_zones" "available" {}
