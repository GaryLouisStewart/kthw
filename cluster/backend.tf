terraform {
  backend "s3" {
    bucket = "kubernetes-the-hard-way"
    key    = "kthw1/kthw.tfstate"
    region = "eu-west-2"
  }
}