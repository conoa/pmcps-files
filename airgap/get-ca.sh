#!/bin/bash

# Download the CA certificate
curl -o /usr/local/share/ca-certificates/ca.crt http://localhost:9090/ca.crt

# Update the CA certificates
update-ca-certificates

echo "CA certificate installed successfully."
