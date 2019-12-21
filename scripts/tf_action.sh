#!/bin/bash

# This script will allow us to run terraform actions and outputs logging into
## the logs folder for the terraform plan function.

# uncomment below to enable debug syntax in script.
# set -x

DATE=$(date '+%Y-%m-%d %H:%M:%S')
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$DIR/../cluster/scripts/path.sh"

# create a <CWD>/.logs folder for terraform to store logs in.
[[ -d "$(pwd)/.logs" ]] || mkdir -p "$(pwd)/.logs"

function tf_init() {
  terraform init
}

function terraform_plan() {
	terraform plan -out=.logs/terraform-plan-log-"$DATE"
}

function terraform_apply() {
	terraform apply -var-file "$TF_VARS/common.json"
}

function terraform_destroy() {
	terraform destroy -var-file "$TF_VARS/common.json"
}

function terraform_output() {
    if [ "$#" -lt 2 ]; then
     echo "Please select a resource to output or see usage with tf_action -h"
     echo "$0: fatal error:" "$@" >&2
     exit 1
    else 
      terraform output "$@"
    fi
}

function usage() {
    echo "usage: [-i, --init, | -a, --apply | -p, --plan | -d, --destroy | -o, --output | -h, --help]"
    echo "  -i  --init    runs a terraform init, e.g. [ \$tf_action -i]"
    echo "  -a, --apply   runs a terraform apply, e.g. [ \$tf_action -a ]"
    echo "  -p, --plan    runs a terraform plan, [ \$tf_action plan -p]"
    echo "  -d, --destory runs a terraform destroy, [ \$tf_action -d ]"
    echo "  -o, --output  runs a terraform output, [ \$tf_action -o <resource-name> ]"
    echo "  -h, --help    display help, [ \$tf_action -hw ]"
    exit 1
}

opt=$1
case $opt
in
    -i| --init)
    tf_init
    ;;
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
