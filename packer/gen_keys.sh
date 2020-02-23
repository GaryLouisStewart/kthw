#!/bin/bash
# creates and uploads a custom ssh keypair to aws for use with packer builds

function gen_keys() {
    if [ $# -lt 1 ]; then
        echo "Please specify a name for the ssh keys you wish to generate"
        echo "usage: $gen_keys.sh -g <example> "
    else
        echo "generating ssh-key $1 and uploading keypair $1 to aws......%"
        ssh-keygen -t rsa -b 4096 -C "administration key pair for $USER" -N '' -f $(pwd)/$1.key
        aws ec2 import-key-pair --key-name "$1" --public-key-material file://$(pwd)/$1.key.pub
    fi
}

function delete_keys(){
  if [ $# -lt 1 ]; then
    echo "Please specify the name of the aws keypair you wish to delete."
    echo  "usage: $gen_keys"
  else
    echo "Deleting aws keypair $1.......%" \
    && aws ec2 delete-key-pair --key-name $1 \
    && echo "deleting ssh keypair $1" \
    && rm $1.key $1*.key.pub
  fi
}

function usage() {
    echo "Usage: ./gen_keys.sh <opts>"
    echo "generate | -g | Generates ssh keys that can be used for packer sshing into our AMI and uploaded to AWS as a keypair"
    echo "delete   | -d | Deletes ssh keys and removes the keypairs from AWS"
    echo "help     | -h | Prints out this help menu."
}

opt=$1
case $opt
in
generate|-g)
    gen_keys "$2"
    ;;
delete|-d)
    delete_keys "$2"
    ;;
help|-h)
    usage
    ;;

*)
    echo "Invalid Usage: please run \$gen_keys.sh -h"
esac
