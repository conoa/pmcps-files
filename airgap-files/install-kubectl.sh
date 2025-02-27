#!/bin/bash

sudo apt update 
sudo apt install curl git -y

wget "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -O /tmp/kubectl

cp /tmp/kubectl ~/bin/kubectl
chmod u+x ~/bin/kubectl
