
################################################
######## terraform backend configuration #######
# this will change depending on name, location #
##### & aws profile that you are using #########
################################################

provider "aws" {
  region                  = "${var.provider_vars["region"]}"
  shared_credentials_file = "${var.provider_vars["shared_creds_file"]}"
  profile                 = "${var.provider_vars["aws_profile"]}"
}