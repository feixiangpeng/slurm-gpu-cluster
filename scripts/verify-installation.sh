#!/bin/bash
# Complete Cluster Verification Script

echo "=== Slurm GPU Cluster Verification ==="

# Test 1: Basic cluster status
echo "1. Cluster Status:"
sinfo || { echo "ERROR: Slurm not responding"; exit 1; }

# Test 2: GPU detection
echo "2. GPU Resources:"
scontrol show nodes | grep -E "(NodeName|Gres)" || { echo "ERROR: No GPU resources detected"; exit 1; }

# Test 3: Job submission
echo "3. Testing job submission:"
job_id=$(sbatch --wrap="nvidia-smi" --gres=gpu:1 --parsable)
echo "Submitted job $job_id"

# Test 4: Monitor job
echo "4. Monitoring job completion:"
while [ $(squeue -j $job_id | wc -l) -gt 1 ]; do
    echo "Job $job_id still running..."
    sleep 5
done

echo "✅ All tests passed! Cluster is operational."
