## variables that must be set

variable "bastion_ami" {
    description = "The AMI to use for the bastion host"
    type = "string"
} 

variable "ssh_keypair" {
    description = "The ssh keypair to use"
    type = "string"
} 

variable "common_tags" {
    description = "Common tags to apply to all our resources"
    type = "list"
}

variable "target_vpc_id" {
    description = "The target VPC to deploy into"
    type = "string"
}

variable "bastion_subnets" {
    description = "bastion_subnets"
    type = "list"
}

variable "bastion_ssh_ingress" {
    description = "The CIDR ranges to allow ssh ingress access to our bastion host"
    type = "list"
}

variable "target_security_group_id" {
    description = "The security groups to give access to our kubernetes"
    type = "list"
}

variable "cidr_range_bastion_access" {
    description = "The CIDR Ranges to allow access to from the bastion host"
    type = "list"
}

# optional vars

variable "instance_type" {
    description = "The type of EC2 instance to use, e.g. t2.micro, m4.xlarge"
    type = "string"
    default = "t2.micro"
}

variable "bastion_count" {
    description = "The number of bastion host servers to spawn"
    default = 1
}
