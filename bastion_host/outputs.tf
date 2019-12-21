output "vpc_id" {
    value = aws_vpc.bastion_vpc.id
}

output "vpc_cidr_block" {
    value = aws_vpc.bastion_vpc.cidr_block
}

output "vpc_route_main" {
    value = aws_vpc.bastion_vpc.main_route_table_id
}