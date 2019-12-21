terraform {
  backend "s3" {
    bucket = "kubernetes-the-hard-way"
    key    = "bastionhost/bastionhost.tfstate"
    region = "eu-west-2"
  }
}