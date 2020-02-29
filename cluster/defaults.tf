variable "provider_vars" {
    description = "Settings for the AWS terraform provider"
    type = "map"
    default = {}
}

variable "ami_worker_node" {
    description = "The worker node AMI"
    type = "string"
    default = ""
}

variable "ami_master_node" {
    description = "The master node AMI"
    type = "string"
    default = ""
}

variable "type_worker_node" {
    description = "The EC2 instance type for the worker node(s) e.g. t2.micro"
    type = "string"
    default = ""
}

variable "type_master_node"  {
    description = "The EC2 instance type for the master node(s) e.g. t2.micro"
    type = "string"
    default = ""
}

variable "ssh_keypair_worker" {
    description = "The ssh keypair name to use for our worker nodes"
    type = "string"
    default = ""
}

variable "ssh_keypair_master" {
    description = "The ssh keypair name to user for our master nodes"
    type = "string"
    default = ""
}

variable "common_tags" {
    description = "Common tags to be applied to all resources"
    type = "map"
    default = {}
}

variable "vpc_vars" {
    description = "VPC core specific settings"
    type = "map"
    default = {}
}

variable "cluster_name" {
    description = "The cluster name to apply used for tagging"
    type = "string"
    default = ""
}

variable "kubernetes_masters_ingress_cidr_range" {
    description = "The ingress CIDR range for the kubernetes master nodes"
    type = "list"
    default = []
}

variable "subnet_kube_workers" {
    description = "The subnets for the kubernetes worker nodes"
    type = "list"
    default = []
}

variable "subnet_kube_masters" {
    description = "The subnets for the kubernetes master nodes"
    type = "list"
    default = []
}

variable "ingress_ports_kubernetes_masters" {
    description = "A list of ports to allow ingress traffic in to our kubernetes masters e.g. 443 for https traffic"
    type = "list"
    default = []
}

# preset variables.

variable "secure_ingress_kubernetes_masters" {
    description = "Whether to enable secure ingress on kubernetes masters"
    default = true
}

variable "insecure_ingress_kubernetes_masters" {
    description = "Allow insecure ingress to kubernetes master nodes"
    default = false
}

variable "worker_node_count" {
    description = "The number of worker nodes to create"
    default = 2
}

variable "master_node_count" {
    description = "The number of master nodes to create"
    default = 1
}

variable "bastion_asg" {
    description = "a map of values that apply to the bastion host asg"
    default = {}
}

variable "launch_config" {
    description = "A map of values that apply to the launch config for the bastion hosts"
    default = {}
}

variable "bastion_count" {
    description = "The number of bastion host ec2 instances to create"
    default = 1
}

variable "instance_type" {
    description = "The instance type to use for the bastion nodes"
    default = "t2.micro"
}

variable "bastion_ami" {
    description = "The Ami to use for the bastion hosts instance"
    default = ""
}

variable "create_asg" {
    description = "whether to create our autoscaling group"
    default = true
}

variable "bastion_subnets" {
    description = "A list of CIDR ranges to use for the bastion host subnets"
    default = []
}
