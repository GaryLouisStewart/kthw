data "http" "myipaddr" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_availability_zones" "available" {}