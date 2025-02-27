#!/bin/bash
set +x

sudo apt-get update 
sudo apt-get -y install wget

mkdir -p ~/bin

wget https://get.helm.sh/helm-v3.17.1-linux-amd64.tar.gz -O /tmp/helm.tar.gz
tar xzvf /tmp/helm.tar.gz -C /tmp/

cp /tmp/linux-amd64/helm ~/bin/helm

