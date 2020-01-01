SHELL := /bin/bash

.PHONY: worker_ami master_ami ssh_cleanup bastion_test bastion_build bastion_destroy kube_test kube_build kube_destroy bastion_validate kube_validate

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

kube_test: cluster/*.tf ## plans the kubernetes infrastructure using terraform
	cd cluster && ../scripts/tf_action.sh -p

kube_build: cluster/*.tf ## create kubernetes infrastructure using terraform
	cd cluster && ../scripts/tf_action.sh -a

kube_destroy: cluster/*.tf ## destroy the kubernetes infrastructure using terraform
	cd cluster && ../scripts/tf_action.sh -d

bastion_validate: bastion_host/*.tf ## runs a terraform validate against files under bastion_host directory
	cd bastion_host && ../scripts/tf_action.sh -v

kube_validate: cluster/*.tf ## runs a terraform validate against files under the cluster directory
	cd cluster && ../scripts/tf_action.sh -v
