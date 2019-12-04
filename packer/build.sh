#!/bin/bash
# runs the packer-build task in order to setup our openvpn Image

DATE_WITH_TIME=$(date "+%Y%m%d-%H%M%S")
PACKER_LOG=1
PACKER_LOG_PATH="$(pwd)./logs-\"$DATE_WITH_TIME\""
directory=logs



[[ -d $(pwd)/.logs ]] || mkdir -p "$(pwd)"./logs

function packer_build() {
    if [ "$#" -lt 2 ]; then
      echo "ERROR: please specify the two variables files"
    else
      echo "Building packer image: ...........%"
      packer build -timestamp-ui -var-file "$2" "$3"
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
    packer_build "$1" "$2"
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
