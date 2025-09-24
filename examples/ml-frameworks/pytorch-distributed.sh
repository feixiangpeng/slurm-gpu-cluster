#!/bin/bash
#SBATCH --job-name=pytorch-distributed
#SBATCH --partition=gpu
#SBATCH --nodes=2
#SBATCH --gres=gpu:2
#SBATCH --time=04:00:00
#SBATCH --output=pytorch-%j.out

# Multi-node distributed training example
export MASTER_PORT=12340
export WORLD_SIZE=4  # 2 nodes × 2 GPUs
export MASTER_ADDR=$(scontrol show hostnames "$SLURM_JOB_NODELIST" | head -n 1)

# Launch distributed training
srun python -m torch.distributed.launch \
    --nproc_per_node=2 \
    --nnodes=2 \
    --node_rank=$SLURM_PROCID \
    --master_addr=$MASTER_ADDR \
    --master_port=$MASTER_PORT \
    train_distributed.py
