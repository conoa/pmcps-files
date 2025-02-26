#!/bin/bash


sudo apt update
sudo apt-get -y install apache2-utils wget curl unzip wget jq

# Step 1. Get zot

sudo chmod +x /usr/bin/zot
sudo chown root:root /usr/bin/zot

# Step 2
#
sudo mkdir -p /etc/zot
sudo tee /etc/zot/config.json > /dev/null <<EOF
{
    "http": {
        "address": "127.0.0.1",
        "port": 8080
    },
    "extensions": {
        "search": {
            "enable": true
        },
        "ui": {
            "enable": true
        },
        "mgmt": {
        "enable": true
        }
    },
    "storage": {
        "rootDirectory": "/data/zot"
    }
}
EOF

# Step 3: Configure a local authentication account
sudo sh -c 'htpasswd -bnB zot zot > /etc/zot/htpasswd'

# Step 4: Define the zot service
sudo tee /etc/systemd/system/zot.service > /dev/null <<EOF
[Unit]
Description=OCI Distribution Registry
Documentation=https://zotregistry.dev/
After=network.target auditd.service local-fs.target

[Service]
Type=simple
ExecStart=/usr/bin/zot serve /etc/zot/config.json
Restart=on-failure
User=zot
Group=zot
LimitNOFILE=500000
MemoryHigh=30G
MemoryMax=32G

[Install]
WantedBy=multi-user.target
EOF

# Step 5: Create a user ID to own the zot service

sudo adduser --no-create-home --disabled-password --gecos --disabled-login zot
sudo mkdir -p /data/zot
sudo chown -R zot:zot /data/zot
sudo mkdir -p /var/log/zot
sudo chown -R zot:zot /var/log/zot
sudo chown -R root:root /etc/zot/

# Step 6: Start zot

sudo systemctl daemon-reload
sudo systemctl enable zot
sudo systemctl start zot

sudo -u zot zot verify /etc/zot/config.json
sudo systemctl status zot

# Step 7: Check the status of the zot service

if [ "$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/v2/)" -eq 200 ]; then
    echo "Zot is running"
else
    echo "Zot is not running"
fi

ls -l /usr/bin/zot

curl -k http://localhost:8080
