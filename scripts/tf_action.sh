#!/bin/bash

# This script will allow us to run terraform actions and outputs logging into
## the logs folder for the terraform plan function.

# uncomment below to enable debug syntax in script.
# set -x

DATE=$(date '+%Y-%m-%d %H:%M:%S')
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "$DIR/../scripts/path.sh" # although the shell complains ( used shellcheck to lint ) this is useful as it allows us to point this to any dynamic path on the system. 

# create a <CWD>/.logs folder for terraform to store logs in.
[[ -d "$(pwd)/.logs" ]] || mkdir -p "$(pwd)/.logs"

function terraform_init() {
  terraform init
}

function terraform_validate() {
  terraform validate
}

function terraform_plan() {
	terraform plan -var-file "$TF_VARS/common.json" -out=.logs/terraform-plan-log-"$DATE"
}

function terraform_apply() {
	terraform apply -var-file "$TF_VARS/common.json"
}

function terraform_destroy() {
	terraform destroy -var-file "$TF_VARS/common.json"
}

function terraform_debug_mode() {
  echo "%....Running a terraform Plan now with debugging mode enabled....%"s
  TF_LOG="debug"
  terraform plan -var-file "$TF_VARS/common.json" -out=.logs/terraform-plan-log-"$DATE"
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
    echo "usage: [-l, --lint | -i, --init, | -a, --apply | -p, --plan | -d, --destroy | -o, --output | -h, --help]"
    echo "  -i  --init     runs a terraform init, e.g. [ \$tf_action -i]"
    echo "  -v  --validate runs a terraform lint, e.g. [ \$tf_action -v]"
    echo "  -a, --apply    runs a terraform apply, e.g. [ \$tf_action -a ]"
    echo "  -p, --plan     runs a terraform plan, [ \$tf_action plan -p]"
    echo "  -d, --destory  runs a terraform destroy, [ \$tf_action -d ]"
    echo "  -o, --output   runs a terraform output, [ \$tf_action -o <resource-name> ]"
    echo "  -h, --help     display help, [ \$tf_action -h ]"
    echo "  -pd, --debug    runs a terraform plan with debugging enabled e,g, [\$tf_action -pd]"
    exit 1
}

opt=$1
case $opt
in
    -i| --init)
    terraform_init
    ;;
    -v| --validate)
    terraform_validate
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
    -pd|--debug)
    terraform_debug_mode
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
