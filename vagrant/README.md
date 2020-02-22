# Local Vagrant cluster for offline studying

### provisons a qemu base virtual machine cluster controlled by vagrant, using two networks a management network for vagrant to run management tasks on the VM's and a custom private network that we will use for communication between the nodes themselves

---


## Instructions for first setup.

```
# create the two dependent networks for vagrant to use
sudo ./bootstrap-networks.sh -c
```

```
# bootstrap the nodes
vagrant up
```

## Command Wiki

```

## virsh command script

# install nfs clients
$ sudo ./bootstrap-networks.sh -n

#  list networks
$ sudo ./bootstrap-networks.sh -l

# create network
$ sudo ./bootstrap-networks.sh -c

# delete network
$ sudo ./bootstrap-networks.sh -d

# show help menu
$ sudo ./bootstrap-networks.sh -h


## vagrant commands

# bring up cluster

$ vagrant up

# destroy cluster

$ vagrant destroy -f

# force provision using provisioners

$ vagrant up --provision

```