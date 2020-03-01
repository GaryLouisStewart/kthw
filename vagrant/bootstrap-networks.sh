#!/usr/bin/env bash
# bootstraps the two networks that are needed for our vagrant setup and setup the nfs packages that are required for vagrant libvirt shared folders.
# author @GaryLouisStewart

declare -a networks=(
    kube-net
    vagrant-mgmt
)

function create_networks() {
# this if statement is very bland. too static for my liking but needed something to get this running quickly. there is probably a safer and better way to do this.
if [[ $(virsh net-list | grep -q -w 'vagrant-mgmt' ) != "vagrant-mgmt" ]] && [[ $(virsh net-list | grep -q -w 'kube-net' ) != "kube-net" ]] ;
then
    for n in "${networks[@]}"
    do
        echo "Creating network ${n}....."
        virsh net-create "${n}".xml
        echo "Network ${n} created."
    done
else
    echo "Networks already exist, exiting...."
    return
fi
}

function remove_networks() {
    for n in "${networks[@]}"
    do
        echo "Removing network ${n}....."
        virsh net-destroy "${n}"
        echo "Network: ${n} removed."
    done
}

function list_networks() {
    echo "Listing all networks....."
    virsh net-list
}

function setup_nfs() {
    echo "setting up nfs mounts"
    echo "Not Implemented yet........%"

}

function usage() {
    echo "Usage: [-c, --create, | -d, --delete,  | -h, --help]"
    echo "-c --create, creates a number of virtual networks that are needed for this demo"
    echo "-d --delete, deletes the virtual networks that were created for this demo"
    echo "-l --list, lists all networks that are currently present under libvirt/qemu/ using virsh"
    echo "-n --setup-nfs, setup the automount, nfs and nfs-clients on the virtual machine"
    echo " -h  --help  display this help menu"
}

opt=$1
case $opt
in
    -c| --create)
    create_networks
    ;;
    -d| --delete)
    remove_networks
    ;;
    -l| --list)
    list_networks
    ;;
    -n| --setup-nfs)
    setup_nfs
    ;;
    -h| --help)
    usage
    ;;
    *)
     echo "Command unknown, for more information run, ./bootstrap-networks.sh -h"
     exit
     ;;
esac
