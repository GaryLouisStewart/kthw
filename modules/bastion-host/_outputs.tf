output "igw_id" {
    value = "${aws_internet_gateway.bastion.id}"
    description = "The aws internet gateway ID"
}
