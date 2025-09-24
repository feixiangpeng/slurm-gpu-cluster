# Complete Slurm GPU Cluster Installation Guide

## Phase 1: Prerequisites and Hardware Setup

### Hardware Requirements
- 1 Controller node: 8GB+ RAM, 4+ CPU cores
- 3+ GPU nodes: NVIDIA GPUs, 32GB+ RAM, 40+ CPU cores
- Network connectivity between all nodes

### Software Prerequisites
```bash
# On all nodes
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential wget curl git vim

# On GPU nodes only
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
sudo apt update
sudo apt install -y nvidia-driver-525 cuda-toolkit-12-0
sudo reboot
nvidia-smi  # Verify installation
# Install munge on all nodes
sudo apt install -y munge libmunge-dev

# Generate key on controller
sudo /usr/sbin/create-munge-key

# Copy to all nodes
sudo scp /etc/munge/munge.key user@gpu-node:/tmp/
sudo cp /tmp/munge.key /etc/munge/
sudo chown munge:munge /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key
sudo systemctl enable --now munge
# Install dependencies
sudo apt install -y python3-dev libssl-dev libpam0g-dev libnuma-dev libhwloc-dev

# Download and compile Slurm
cd /tmp
wget https://download.schedmd.com/slurm/slurm-21.08.5.tar.bz2
tar xjf slurm-21.08.5.tar.bz2
cd slurm-21.08.5
./configure --prefix=/usr/local/slurm --with-systemd --enable-pam
make -j$(nproc)
sudo make install
### 2. Troubleshooting Guide with Real Issues
```bash
cat > docs/troubleshooting.md << 'EOF'
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
# Check munge authentication
munge -n | ssh gpu-node unmunge
# Restart services in order
sudo systemctl restart munge
sudo systemctl restart slurmctld  # controller only
sudo systemctl restart slurmd     # GPU nodes only
# Verify munge keys are identical
sudo md5sum /etc/munge/munge.key  # Run on all nodes
# Restart munge services if different
### 3. Complete Working Configuration Examples
```bash
# Create working config templates
cat > configs/slurm.conf.working-example << 'EOF'
# Working Slurm Configuration - Based on kl35 Cluster
ClusterName=gpu-cluster
ControlMachine=controller-hostname
ControlAddr=YOUR_CONTROLLER_IP

# Authentication (REQUIRED)
AuthType=auth/munge
CryptoType=crypto/munge

# Scheduling (Tested Configuration)
SchedulerType=sched/backfill
SelectType=select/cons_tres
SelectTypeParameters=CR_Core_Memory

# Logging
SlurmUser=slurm
SlurmdUser=slurm
SlurmctldLogFile=/var/log/slurm/slurmctld.log
SlurmdLogFile=/var/log/slurm/slurmd.log

# Node Definitions (Adjust for your hardware)
NodeName=gpu-node-1 NodeAddr=YOUR_GPU_NODE_1_IP CPUs=40 Sockets=2 CoresPerSocket=10 ThreadsPerCore=2 RealMemory=64000 State=UNKNOWN
NodeName=gpu-node-2 NodeAddr=YOUR_GPU_NODE_2_IP CPUs=40 Sockets=2 CoresPerSocket=10 ThreadsPerCore=2 RealMemory=64000 State=UNKNOWN
NodeName=gpu-node-3 NodeAddr=YOUR_GPU_NODE_3_IP CPUs=40 Sockets=2 CoresPerSocket=10 ThreadsPerCore=2 RealMemory=64000 State=UNKNOWN

# Partition Definition
PartitionName=gpu Nodes=gpu-node-[1-3] Default=YES MaxTime=INFINITE State=UP
