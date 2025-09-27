# Monitoring Setup Guide

## Prometheus Installation

Run the automated script:
```bash
./scripts/monitoring/setup-prometheus.sh
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['controller:9100', 'gpu-node-1:9100', 'gpu-node-2:9100', 'gpu-node-3:9100']

  - job_name: 'gpu-exporter'
    static_configs:
      - targets: ['gpu-node-1:9400', 'gpu-node-2:9400', 'gpu-node-3:9400']
    scrape_interval: 5s
sudo systemctl daemon-reload
sudo systemctl enable --now prometheus
