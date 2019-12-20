#!/bin/bash
# This script will allow us to run terraform actions and outputs logging into
## the logs folder with each of the logs labelled to their respective actio

DATE=$(date '+%Y-%m-%d %H:%M:%S')

# create a <CWD>/.logs folder for terraform to store logs in.
[[ -d $(pwd)/.logs ]] || mkdir -p "$(pwd)"/.logs

function terraform_plan() {
	terraform plan -out=./logs/terraform-plan-log-"$DATE"
}

function terraform_apply() {
	terraform apply --var-file=../terraform.tfvars -out=./logs/terraform-apply-log-"$DATE"
}

function terraform_destroy() {
	terraform destroy --var-file=../terraform.tfvars -out=./logs/terraform-destroy-log-"$DATE"
}

function terraform_output() {
    if [ "$#" -lt 2 ]; then
     echo "Please select a resource to output or see usage with tf_action -h"
    else 
      terraform output "$@"
    fi
}

function usage() {
    echo "usage: [-a, --apply | -p, --plan | -d, --destroy | -o, --output | -h, --help]"
    echo "  -a, --apply   runs a terraform apply, e.g. [ \$tf_action apply ]"
    echo "  -p, --plan    runs a terraform plan, [ \$tf_action plan ]"
    echo "  -d, --destory runs a terraform destroy, [ \$tf_action destroy ]"
    echo "  -o, --output  runs a terraform output, [ \$tf_action output <resource-name> ]"
    echo "  -h, --help    display help, [ \$tf_action help ]"
    exit 1
}

opt=$1
case $opt
in
    -p| --plan)
    terraform_plan
    ;;
    -a|--apply)
    terraform_apply
    ;;
    -d|--destroy)
    terraform_destroy
    ;;
    -o|--output)
    terraform_output "$1"
    ;;
    -h|--help)
    usage
    ;;
  *)
    echo "Command unknown, for more information run, tf_action --help"
    exit
        ;;
esac
