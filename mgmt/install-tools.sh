#!/bin/bash

sudo apt-get -y update
sudo apt-get -y install gnupg vim net-tools pass
sudo apt-get -y install ansible python3 python3-venv
sudo apt-get -y install jq yq docker.io helm

wget https://get.helm.sh/helm-v3.17.1-linux-amd64.tar.gz -O /tmp/helm.tar.gz
tar xvf /tmp/helm.tar.gz -C /tmp/
cp /tmp/linux-amd64/helm /tmp/helm

wget https://github.com/kubernetes-sigs/krew/releases/download/v0.4.4/krew-linux_amd64.tar.gz -O /tmp/krew.tar.gz
tar xvf /tmp/krew.tar.gz -C /tmp
tar xvf /tmp/krew.tar.gz -C /tmp


