# Slurm GPU Cluster Deployment

Automated deployment for Slurm-based GPU clusters using Ansible.

## Prerequisites
- Ansible installed locally
- SSH access to cluster nodes
- Sudo privileges on target nodes

## Quick Start
1. Edit `ansible/inventory/hosts.yml` with your node IPs
2. Run: `ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/site.yml`
3. Verify: `sinfo` to check cluster status

## Architecture
- Controller node: Runs slurmctld daemon
- GPU nodes: Run slurmd daemons with GPU detection
- Automatic resource allocation via Slurm

## Job Submission Examples
```bash
# Single GPU job
srun --partition=gpu --gres=gpu:1 nvidia-smi

# Multi-GPU job
srun --partition=gpu --gres=gpu:2 nvidia-smi
