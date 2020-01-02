SHELL := /bin/bash

.PHONY: worker_ami master_ami ssh_cleanup cluster_test cluster_build cluster_destroy cluster_validate bastion_validate kubernetes_cluster_validate sanity_test

all: help

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'

help: 								## show this help
		@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

worker_ami: packer/*.json ## builds the packer-ami for the worker nodes
	cd packer  \
	&& ./gen_keys.sh -g worker-nodes \
	&& ./build.sh -b worker

master_ami: packer/*.json ## builds the packer-ami for the master nodes
	cd packer \
	&& ./gen_keys.sh -g master-nodes \
	&& ./build.sh -b master

ssh_cleanup: packer/* ## cleanup the old ssh-keys in the packer-directory for worker and master nodes
	cd packer \
	&& ./gen_keys.sh -d worker-nodes \
	&& ./gen_keys.sh -d master-nodes

cluster_test: cluster/*.tf ## plans the kubernetes infrastructure using terraform
	cd cluster && ../scripts/tf_action.sh -p

cluster_build: cluster/*.tf ## create kubernetes infrastructure using terraform
	cd cluster && ../scripts/tf_action.sh -a

cluster_destroy: cluster/*.tf ## destroy the kubernetes infrastructure using terraform
	cd cluster && ../scripts/tf_action.sh -d

bastion_validate: modules/bastion-host/*.tf ## runs a terraform validate against files under the modules/bastion-host module
	cd modules/bastion-host && ../../scripts/tf_action.sh -i && ../../scripts/tf_action.sh -v

cluster_validate: modules/ec2-cluster/*.tf ## runs a terraform validate against files under the modules/ec2-cluster module
	cd modules/ec2-cluster && ../../scripts/tf_action.sh -i && ../../scripts/tf_action.sh -v

kubernetes_cluster_validate: cluster/*.tf ## runs a terraform validate against the kubernetes cluster we are using with the two modules
	cd cluster && ../../scripts/tf_action.sh -i && ../scripts/tf_action.sh -v

sanity_test: tests/go_sanity_test.go ## runs a small test in order to check golang
   cd tests && go test -v