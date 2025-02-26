#!/bin/bash

# Install nginx
sudo apt-get update
sudo apt-get -y install nginx

# Setup CA tool and directory
sudo mkdir -p /opt/bin
sudo cp gen-ca.sh /opt/bin/
sudo chmod +x /opt/bin/gen-ca.sh
sudo mkdir -p /opt/certs

# Verify it, replace SAN with correct one
cd /opt || exit
sudo /opt/bin/gen-ca.sh generate-ca
sudo /opt/bin/gen-ca.sh issue-cert localhost localhost
openssl x509 -in /opt/certs/localhost.crt -text -noout
ls -l /opt/certs

# Install Zot
wget https://github.com/project-zot/zot/releases/download/v2.1.2/zot-linux-amd64 -O /tmp/zot
sudo cp /tmp/zot /usr/bin/zot
sudo mkdir -p /opt/bin
sudo chmod +x /usr/bin/zot
sudo chown root:root /usr/bin/zot

# Install dist directory
sudo mkdir -p /var/www/html/dist
