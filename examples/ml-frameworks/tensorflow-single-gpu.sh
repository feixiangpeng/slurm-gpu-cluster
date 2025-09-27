#!/bin/bash
#SBATCH --job-name=tensorflow-training
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --time=02:00:00
#SBATCH --mem=16G
#SBATCH --output=tensorflow-%j.out

# Set TensorFlow GPU memory growth
export TF_FORCE_GPU_ALLOW_GROWTH=true

# Load environment
source /opt/anaconda/bin/activate tensorflow_env

# Run training
python model_train.py --use-gpu --data-dir /data --output-dir /results
