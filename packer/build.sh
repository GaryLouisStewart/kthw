#!/bin/bash
# packer builder for our worker nodes & 

DATE_WITH_TIME=$(date "+%Y%m%d-%H%M%S")
PACKER_LOG=1
PACKER_LOG_PATH="$(pwd)./logs-\"$DATE_WITH_TIME\""
directory=logs



[[ -d $(pwd)/.logs ]] || mkdir -p "$(pwd)"./logs

function packer_build() {
    if [[ "$2" == "worker" ]]; then
      echo "Building packer image for kubernetes worker: ...........%"
      packer build -timestamp-ui -var-file node-vars.json worker-nodes.json
    elif [[ "$2" == "master" ]]; then
      echo "Building packer image for kubernetes masters: ..........%"
      packer build -timestamp-ui -var-file master-vars.json master-nodes.json
    else
        echo "Please specify either 'worker' or 'master' as arguments'"
        echo "$0: fatal error:" "$@" >&2
        exit 1
    fi
}

function remove_old_dir() {
    rm -rvf $directory
}

function usage() {
    echo "Usage: ./openvpn_build.sh <opts>"
    echo "Build | FLG | build, -b | Builds the raw packer-image"
    echo "Remove DIR | FLG | rmdir,-rm | Removes the logs directory"
    echo "Print Help | FLG | help, -h | Prints out this helper text"
}

opt=$1
case $opt
in

build|-b)
    packer_build "$@"
    ;;
rmdir|-rm)
    remove_old_dir
    ;;
help|-help)
    usage
    ;;
*)
    echo "Invalid Usage: please run \$build.sh -help"
esac
