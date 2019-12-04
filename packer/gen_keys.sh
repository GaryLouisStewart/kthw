#!/bin/sh
# creates and uploads a custom ssh keypair to aws for use with packer builds

if [[ $# -lt 1 ]]; then
    echo "Please specify a name for the ssh keys you wish to generate"
    echo "usage: $gen_keys.sh example"
else
    ssh-keygen -t rsa -b 4096 -C "administration key pair for $USER" -N '' -f $(pwd)/$1.key
    aws ec2 import-key-pair --key-name "$1" --public-key-material file://$(pwd)/$1.key.pub
fi
