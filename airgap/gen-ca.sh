#!/bin/bash

# Variables
CA_DIR="./ca"
CERTS_DIR="./certs"
CA_KEY="$CA_DIR/ca.key"
CA_CERT="$CA_DIR/ca.crt"
OPENSSL_CNF="openssl.cnf"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Create directories
mkdir -p $CA_DIR $CERTS_DIR

# Function to generate or overwrite CA
generate_ca() {
  if [ -f "$CA_KEY" ] || [ -f "$CA_CERT" ]; then
    read -p "CA already exists. Do you want to overwrite it? (yes/no): " choice
    if [ "$choice" != "yes" ]; then
      echo -e "${RED}CA generation aborted.${NC}"
      exit 1
    fi
  fi

  # Generate CA private key
  openssl genpkey -algorithm RSA -out $CA_KEY -pkeyopt rsa_keygen_bits:2048

  # Generate CA certificate
  openssl req -x509 -new -nodes -key $CA_KEY -sha256 -days 3650 -out $CA_CERT -subj "/C=SE/ST=Stockholm/L=Stockholm/O=ExampleCompany/OU=IT Department/CN=ExampleCA"

  echo -e "${GREEN}CA generated at $CA_DIR${NC}"
}

# Function to create TLS certificates with SAN
create_tls_cert() {
  local domain=$1
  local san=$2
  local key_file="$CERTS_DIR/$domain.key"
  local csr_file="$CERTS_DIR/$domain.csr"
  local cert_file="$CERTS_DIR/$domain.crt"

  # Create OpenSSL configuration file for SAN
  cat > $OPENSSL_CNF <<EOL
[req]
default_bits       = 2048
distinguished_name = req_distinguished_name
req_extensions     = req_ext
prompt             = no

[req_distinguished_name]
countryName                = SE
stateOrProvinceName        = Stockholm
localityName               = Stockholm
organizationName           = ExampleCompany
organizationalUnitName     = IT Department
commonName                 = $domain
emailAddress               = admin@example.com

[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1   = $san
EOL

  # Generate private key
  openssl genpkey -algorithm RSA -out $key_file -pkeyopt rsa_keygen_bits:2048

  # Generate CSR
  openssl req -new -key $key_file -out $csr_file -config $OPENSSL_CNF

  # Generate certificate signed by CA
  openssl x509 -req -in $csr_file -CA $CA_CERT -CAkey $CA_KEY -CAcreateserial -out $cert_file -days 365 -sha256 -extfile $OPENSSL_CNF -extensions req_ext

  echo -e "${GREEN}Certificate for $domain with SAN $san created at $cert_file${NC}"
}

# Function to list issued certificates with details
list_certs() {
  echo -e "${BLUE}Issued certificates:${NC}"
  for cert in $CERTS_DIR/*.crt; do
    if [ -f "$cert" ]; then
      echo -e "${YELLOW}Filename: $(basename $cert)${NC}"
      openssl x509 -in $cert -noout -subject -issuer -dates | while read -r line; do
        echo -e "${GREEN}$line${NC}"
      done
      echo -e "${BLUE}----------------------------------------${NC}"
    else
      echo -e "${RED}No certificates found.${NC}"
    fi
  done
}

# Main script
case "$1" in
  generate-ca)
    generate_ca
    ;;
  issue-cert)
    if [ -z "$2" ] || [ -z "$3" ]; then
      echo -e "${RED}Usage: $0 issue-cert <domain> <SAN>${NC}"
      exit 1
    fi
    create_tls_cert "$2" "$3"
    ;;
  list-certs)
    list_certs
    ;;
  *)
    echo -e "${RED}Usage: $0 {generate-ca|issue-cert <domain> <SAN>|list-certs}${NC}"
    exit 1
    ;;
esac
