variable "provider_vars" {
    description = "Map of different variables to pass to our AWS instance as the provider"
    type = "map"
    default = {}
}

variable "common_tags" {
    description = "Map of tags that can be applied to all our resources"
    type = "map"
    default = {}
}

variable "vpc_vars" {
    description  = "Map of variables applying to the VPC that we will use to host our bastion server"
    type = "map"
    default = {}
}

variable "bastion_ami_name" {
    description = "AMI to use for the EC2 instance that will be our bastion host"
    type = "string"
    default = ""
}

variable "bastion_ssh_keypair" {
    description = "SSH keypair to use for our bastion host"
    type = "string"
    default = ""
}

variable "aws_instance_type" {
    description = "The aws instance type to use e.g. t2.micro"
    type = "string"
    default = ""
}

variable "associate_bastion_public_ip" {
    description = "Whether or not to allow a public IP address for the EC2 bastion host"
    default  = false
}

variable "cidr_block_bastion" {
    description = "The CIDR blocks to allow ssh access to the bastion host"
    type = "list"
    default = []
}

variable "create_bastion_insecure" {
    description = "Optional CIDR Range allowing insecure ssh access into our instance"
    default = false
}

variable "create_bastion_secure" {
    description = "Optional CIDR Range allowing secure ssh access into our instance"
    default = false
}
