variable "provider_vars" {
    description = "Map of different variables to pass to our AWS instance as the provider"
    type = "map"
    default = {}
}

variable "kube_ami_names" {
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
