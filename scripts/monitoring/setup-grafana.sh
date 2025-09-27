#!/bin/bash
# Automated Grafana Setup Script

echo "Setting up Grafana..."

# Add Grafana repository
sudo apt-get install -y software-properties-common
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

# Install Grafana
sudo apt-get update
sudo apt-get install grafana

# Start and enable Grafana
sudo systemctl daemon-reload
sudo systemctl enable --now grafana-server

echo "Grafana installed. Access at http://your-server:3000 (admin/admin)"
echo "Remember to change default password on first login."
