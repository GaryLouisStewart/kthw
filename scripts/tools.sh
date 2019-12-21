#!/bin/sh
# install the tools we will need in order to proceed with this excercise, this will only work on *nix distributions and installs the latest version

# installs the latest version of the kubectl binary directly from google.
KUBECTL_BIN=kubectl

if [ -z $(which $KUBECTL_BIN) ]; then 
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt/bin/linux/amd64/$KUBECTL_BIN)
    chmod +x ${KUBECTL_BIN}
    sudo mv ${KUBECTL_BIN} /usr/local/bin/${KUBECTL_BIN}
else
    echo "Kubectl is already installed exiting"
    exit
fi

# sets our aliases for kns & kctx to set the current namespace and check the current namespace that you are working in
printf "alias kubens='f(){ kubectl config set-context $(kubectl config current-context) --namespace=\"$@;\"  unset -f f; }; f' " >> ~/.bash_profile
printf "alias chkns='kubectl config view  | grep namespace:'" >> ~/.bash_profile

# generate a custom ssh keypair that we can use later on rather than using your standard ssh-keypair. This is useful for administering the ec2 instances in this tutorial

SSH_KEYS=~/.ssh/gsadmin_key
USER="Gary Louis Stewart"
if [ ! -f "$SSH_KEYS" ];
then
    printf "\nCreating SSH Keys....."
    ssh-keygen -t rsa -b 4096 -C "administration key pair for $USER" -N '' -f ~/.ssh/gs_admin.key
else
    printf "\nSSH Keypair for $USER is already in place exiting..."
    exit
fi
