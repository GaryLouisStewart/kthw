output "bastion_instance_ids" {
    value = aws_instance.bastion-instance.*.id
    description = "bastion host ec2 instance ids"
}

output "igw_id" {
    value = aws_internet_gateway.bastion.id
    description = "The aws internet gateway ID"
}
