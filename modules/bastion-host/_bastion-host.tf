# autoscaling groups.

resource "aws_launch_configuration" "bastion_conf" {
  name_prefix = "bastion-host-lc-"
  image_id = "${var.bastion_ami}"
  instance_type = "${var.instance_type}"
  associate_public_ip_address = false
  security_groups = ["${aws_security_group.bastion-ssh.id}"]
  user_data = "${data.template_file.bastion-user-data_common.rendered}"
  key_name = "${var.ssh_keypair}"
    root_block_device {
      volume_size = "${var.launch_config["root_vol_size"]}"
      volume_type = "${var.launch_config["root_vol_type"]}}"
      encrypted = "${var.launch_config["root_vol_encrypted"]}"
    }

    lifecycle {
    create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "bastion-asg" {
    count = "${var.create_asg ? 1 : 0}"
    name = "bastion-host-asg"
    launch_configuration = "${aws_launch_configuration.bastion_conf.id}"
    availability_zones = ["${data.aws_availability_zones.available.names[0]}, ${data.aws_availability_zones.available.names[1]}"]
    vpc_zone_identifier = ["${aws_subnet.bastion-public-subnet.count}"]
    max_size = "${var.asg["asg_max"]}"
    min_size = "${var.asg["asg_min"]}"
    desired_capacity = "${var.asg["asg_desired"]}"
    health_check_grace_period = "${var.asg["health_check_grace"]}"
    health_check_type = "${var.asg["health_check_type"]}"

    lifecycle {
        create_before_destroy = true
    }

    tags = ["${merge(map(
        "Name", "Bastion host",
        "propagate_at_launch", "true"
         ),  var.common_tags)}"]
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "test_profile"
  role = "${aws_iam_role.bastion_role.name}"
}

resource "aws_iam_role" "bastion_role" {
    name = "bastion_role"
    path = "/"

    assume_role_policy = "${file("${path.module}/templates/bastion-iam.tpl")}"
}

resource "aws_eip" "bastion-host" {
    count = "${var.bastion_count}"
    vpc = true

    lifecycle {
        create_before_destroy = true
    }

    tags = "${merge(map(
        "Name", "Bastion host elastic ip address",
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
