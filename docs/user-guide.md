# User Guide

## Submitting Jobs

### Interactive Jobs
```bash
srun --partition=gpu --gres=gpu:1 --pty bash
cat > job.sh << 'JOBEOF'
#!/bin/bash
#SBATCH --job-name=my-job
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --time=01:00:00

python train.py
JOBEOF

sbatch job.sh
Monitor jobs
squeue                    # View job queue
squeue -u $USER          # View your jobs
scontrol show job <ID>   # Job details
scancel <ID>             # Cancel job
