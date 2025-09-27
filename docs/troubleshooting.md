# Troubleshooting Guide

## Common Issues and Solutions

### Issue 1: GPU Resources Not Detected
**Symptoms**: `scontrol show node` shows `Gres=(null)`
**Root Cause**: Incorrect gres.conf configuration
**Solution**:
```bash
# Ensure gres.conf contains only:
echo "AutoDetect=nvml" | sudo tee /etc/slurm/gres.conf
sudo systemctl restart slurmd
"
# Check munge authentication
munge -n | ssh gpu-node unmunge
# Restart services in order
sudo systemctl restart munge
sudo systemctl restart slurmctld  # controller only
sudo systemctl restart slurmd     # GPU nodes only
# Verify munge keys are identical
sudo md5sum /etc/munge/munge.key  # Run on all nodes
# Keys must be identical - if different, recopy from controller
