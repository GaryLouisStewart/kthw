output "vpc_id" {
    value = aws_vpc.kubernetes_vpc.id
    description = "The VPC id of our kubernetes cluster"
}

output "security_group_id" {
    value = aws_security_group.kubernetes_masters.id
    description = "The Kubernetes security group ID"
}
