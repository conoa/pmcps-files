#!/bin/bash

# Install nginx
sudo apt-get update
sudo apt-get -y install nginx

# Setup CA tool and directory
sudo mkdir -p /opt/bin
sudo cp gen-ca.sh /opt/bin/
sudo chmod +x /opt/bin/gen-ca.sh
sudo mkdir -p /opt/certs

# Verify it
cd /opt
sudo /opt/bin/gen-ca.sh generate-ca
sudo /opt/bin/gen-ca.sh issue-cert localhost localhost
openssl x509 -in /opt/certs/localhost.crt -text -noout
ls -l /opt/certs
