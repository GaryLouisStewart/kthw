# data sources file

data "http" "myipaddr" {
  url = "http://ipv4.icanhazip.com"
}

data  "aws_availability_zones" "available" {}

data "template_file" "bastion-user-data_common" {
  template = "${file("${path.module}/templates/bastion-user-data_common.tpl")}"
}

data "template_cloudinit_config" "userdata" {
  gzip = true
  base64_encode = true

  part {
    filename = "init.cfg"
    content_type = "text/x-shellscript"
    content = "${data.template_file.bastion-user-data_common.rendered}"
  }

}
