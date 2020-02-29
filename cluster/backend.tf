terraform {
  backend "s3" {
    bucket = "kubernetes-the-hard-way"
    key    = "kthw1/kubethehardway.tfstate"
    region = "eu-west-2"
  }
  required_version = "> 0.11.7"
}
