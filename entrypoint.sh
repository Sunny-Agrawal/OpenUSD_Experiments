#!/bin/bash

# Ensure Conda is initialized for this session
source /opt/conda/etc/profile.d/conda.sh

# Check if the Conda environment exists
if [ ! -d "/opt/conda/envs/openusd_env" ]; then
    echo "Conda environment does not exist. Creating..."
    /opt/conda/bin/conda env create -f /tmp/environment.yml -p /opt/conda/envs/openusd_env
else
    echo "Conda environment exists. Updating..."
    /opt/conda/bin/conda env update -f /tmp/environment.yml -p /opt/conda/envs/openusd_env
fi

# Activate the Conda environment
echo "Activating Conda environment..."
conda activate /opt/conda/envs/openusd_env

# Pass control to CMD or keep container running
exec "$@"
