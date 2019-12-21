terraform {
  backend "s3" {
    bucket = "kubernetes-the-hard-way"
    key    = "kubernetes/kthw/tf.state"
    region = "eu-west-2"
  }
}