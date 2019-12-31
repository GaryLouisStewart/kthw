variable "provider_vars" {
    description = "Map of different variables to pass to our AWS instance as the provider"
    type = "map"
    default = {}
}

variable "kube_amis" {
    description = "Map of ami names for worker and master nodes"
    type = "map"
    default = {}
}

variable "node_count" {
    description = "Map of node count numbers, for increasing or decreasing the amount of master and worker nodes"
    type = "map"
    default = {}
}

variable "common_tags" {
    description = "Map of common tags to apply to all resources that are created with terraform"
    type = "map"
    default = {}
}

variable "vpc_vars" {
    description = "map of variables that apply to our VPC we are creating for kubernetes"
    type = "map"
    default = {}
}

variable "cluster_name" {
    description = "The kubernetes cluster name"
    type = "string"
    default = ""
}

variable "associate_pub_ip_master" {
    description = "Public ip address for master nodes"
    default = false
}

variable "associate_pub_ip_worker" {
    description = "Public ip address for worker nodes"
    default = false
}

variable "aws_keypair_name" {
    description = "A map of keypair names, one for the worker nodes and one for the master nodes."
    type = "map"
    default = {}
}

variable "kubemaster_cidr_ingress_access" {
    description = "A list of CIDR ranges to allow into the API server ( master node) e.g. 10.0.2.30/22"
    type = "list"
    default = []
}

variable "kubemaster_secure_ingress" {
    description = "use secure ingress e.g. specifying your own range that is behind a VPN or bastion server not exposing directly to 0.0.0.0/0"
    default = true
}

variable "kubemaster_insecure_ingress" {
    description = "Use insecure ingress e.g. opening directly to 0.0.0.0/0 or your own public IP"
    default = false
}

variable "kubemaster_ingress_ports" {
    description = "A list of ports to allow ingress traffic into our master nodes"
    type = "list"
    default = []
}

variable "kube_node_type" {
    description = "A map of different instance types for master and workers"
    type = "map"
    default = {}
}

variable "kube_master_subnet" {
    description = "A list of public "
    type = "list"
    default = []
}

variable "kube_worker_subnet" {
    description = "A list of private subnets to create"
    type = "list"
    default = []
}
