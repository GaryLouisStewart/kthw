#!/bin/bash
alias k=kubectl

# check to see if kubectl is installed

KUBECTL_BIN=kubectl

function install_kubectl() {
    if [ -v $KUBECTL_BIN ]
       then 
           curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt/bin/linux/amd64/$KUBECTL_BIN)
           chmod +x ${KUBECTL_BIN}
           sudo mv ${KUBECTL_BIN} /usr/local/bin/${KUBECTL_BIN}
       else
           echo "Kubectl is already installed exiting"
           exit
      fi
}
# switch namespace dynamically by callling kubens <namespace-name>
alias kubens='f(){ kubectl config set-context $(kubectl config current-context) --namespace="$@";  unset -f f; }; f'

# check current namespace
alias chkns='kubectl config view  | grep namespace:'

# generate some new SSH KEYS for ssh-administration
SSH_KEYS=~/.ssh/gsadmin_key
USER="Gary Louis Stewart"
if [ ! -f "$SSH_KEYS" ]
then
    echo -e "\nCreating SSH Keys....."
    ssh-keygen -t rsa -b 4096 -C "administration key pair for $USER" -N '' -f ~/.ssh/gs_admin.key
else
    echo -e "\nSSH Keypair for $USER is already in place exiting..."
    exit
fi

alias ..="cd .."
alias fhere="find . -name"

export GOPATH="$HOME/go"
PATH="$GOPATH/bin:$PATH"