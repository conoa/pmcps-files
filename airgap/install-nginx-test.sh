#!/bin/bash

docker cp ~/scripts/gen-ca.sh airgap:/opt/bin/gen-ca.sh

# Setup CA tool and directory
docker exec -it airgap chmod +x /opt/bin/gen-ca.sh
docker exec -it airgap mkdir -p /opt/certs
docker exec -w /opt/certs/ca -it airgap pwd
docker exec -w /opt/certs -it airgap /opt/bin/gen-ca.sh generate-ca
docker exec -w /opt/certs -it airgap cat ca/ca.crt
docker cp ./get-ca.sh airgap:/usr/bin/get-ca.sh
docker exec -it airgap chmod +x /usr/bin/get-ca.sh

docker exec -w /opt/certs -it airgap /opt/bin/gen-ca.sh generate-ca
docker exec -w /opt/certs -it airgap /opt/bin/gen-ca.sh issue-cert localhost localhost
docker exec -w /opt/certs -it airgap ls /opt/certs
docker exec -w /opt/certs -it airgap cat localhost/localhost.crt

docker exec -w /opt/certs -it airgap openssl x509 -in certs/localhost.crt -text -textonly
docker exec -w /opt/certs -it airgap ls /opt/certs/certs/localhost.crt

# Install nginx
sudo apt update
sudo apt -y install nginx


sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
server {
    listen 80;
    server_name localhost;

    location /ca.crt {
        alias /opt/certs/ca/ca.crt;
    }

    location /get-ca.sh {
        alias /usr/bin/get-ca.sh;
        add_header Content-Type application/x-sh;
    }
}

server {
    listen 443 ssl;
    server_name localhost;

    ssl_certificate /opt/certs/certs/localhost.crt;
    ssl_certificate_key /opt/certs/certs/localhost.key;

    location /dist/ {
        root /var/www/html;
        autoindex on;  # Enable directory listing
        autoindex_exact_size off;  # Show file sizes in human-readable format
        autoindex_localtime on;  # Show file times in local time zone
    }

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF


# Test Nginx configuration
if ! sudo nginx -t; then
    echo "Nginx configuration test failed"
    exit 1
fi

# Reload Nginx to apply the new configuration
sudo systemctl reload nginx

# Enable Nginx to start on boot
sudo systemctl enable nginx

# Start Nginx service
sudo systemctl start nginx

# Check the status of the Nginx service
sudo systemctl status nginx

# Verify Nginx is running by checking the HTTP status code
if [ "$(curl -s -o /dev/null -w "%{http_code}" http://localhost)" -eq 200 ]; then
    echo "Nginx is running"
else
    echo "Nginx is not running"
fi
