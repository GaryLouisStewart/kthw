#!/bin/bash
# install necessary packages in order for kubernetes to work properly on ubuntu 16.04
KUBECTL_BIN=kubectl
DOCKER_BIN=docker
PROVISION_KUBE="true"

if [ -v $(which $KUBECTL_BIN) ]; then
    curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/$KUBECTL_BIN \
    && chmod +x ${KUBECTL_BIN} \
    && sudo mv ${KUBECTL_BIN} /usr/local/bin/${KUBECTL_BIN}
else
    echo "Kubectl is already installed exiting"
    exit
fi


if [ "$PROVISION_KUBE" == "true" ]; then
    echo "Installing Kubernetes packages"
    apt-get update -qq \
    && apt-get upgrade -qq \
    && sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add \
    && touch /etc/apt/sources.list.d/kubernetes.list \
    && echo -n "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list \
    && sudo apt-get update -y -qq \
    && sudo apt-get install -y -qq kubelet kubeadm kubectl kubernetes-cni
else
    echo "Kubelet is already installed exiting...."
    exit
fi

if [ -v $(which $DOCKER_BIN) ]; then
    echo "Installing docker"....
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
    && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && sudo apt-get -y update \
    && apt-cache policy docker-ce \
    && sudo apt-get install -y docker-ce
else
    echo "Docker already installed exiting...."
    exit
fi


