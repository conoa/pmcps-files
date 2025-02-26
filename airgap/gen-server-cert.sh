#!/bin/bash

cd /opt || exit
sudo /opt/bin/gen-ca.sh issue-cert ec2-13-50-126-32.eu-north-1.compute.amazonaws.com ec2-13-50-126-32.eu-north-1.compute.amazonaws.com
openssl x509 -in /opt/certs/ec2-13-50-126-32.eu-north-1.compute.amazonaws.com.crt -text -noout
ls -l /opt/certs
cat /etc/nginx/sites-available/default
