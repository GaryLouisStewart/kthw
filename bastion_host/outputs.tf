output "vpc_id" {
    value = aws_vpc.bastion_vpc.id
}

output "vpc_cidr_block" {
    value = aws_vpc.bastion_vpc.cidr_block
}

output "vpc_route_main" {
    value = aws_vpc.bastion_vpc.main_route_table_id
}

output "bastion-sg-id" {
    value = aws_security_group.bastion-inbp.id
}

output "bastion-pub-ip" {
    value = "${aws_instance.bastion.public_ip}"
}
