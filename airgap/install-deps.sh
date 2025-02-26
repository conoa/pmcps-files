#!/bin/bash

sudo apt-get update
sudo apt-get -y install nginx

# Setup CA tool and directory
sudo cp gen-ca.sh /opt/bin
sudo chmod +x /opt/bin/gen-ca.sh
sudo mkdir -p /opt/certs
