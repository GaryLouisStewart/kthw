output "bastion_instance_ids" {
    value = aws_instance.bastion-instance.count.index.id
    description = "bastion host ec2 instance ids"
}

output "bastion_ips" {
    value = aws_eip.bastion_eip.count.index.public_ip
    description = "Bastion host Elastic IP addresses"
}

output "igw_id" {
    value = aws_internet_gateway.bastion.id
    description = "The aws internet gateway ID"
}