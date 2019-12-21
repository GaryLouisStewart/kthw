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