# ---------------------------------------------------------------------------
# Base Image: Ubuntu with CUDA for GPU acceleration (adjust CUDA version as needed)
# ---------------------------------------------------------------------------
    FROM nvidia/cuda:12.0.1-devel-ubuntu22.04

    # ---------------------------------------------------------------------------
    # Install basic dependencies
    # ---------------------------------------------------------------------------
    RUN apt-get update && apt-get install -y \
        build-essential \
        bash-completion \
        cmake \
        git \
        wget \
        nvidia-container-toolkit\
        libglu-dev libxinerama-dev libxcursor-dev libxi-dev \
        libxrandr-dev libx11-dev \
        x11-apps \
        xvfb \
        && rm -rf /var/lib/apt/lists/*
    
    # ---------------------------------------------------------------------------
    # Install Miniconda for Python and Conda package management
    # ---------------------------------------------------------------------------
    RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
        bash miniconda.sh -b -p /opt/conda && \
        rm miniconda.sh && \
        /opt/conda/bin/conda clean -t -i -p -y
    ENV PATH=/opt/conda/bin:$PATH
    
    # ---------------------------------------------------------------------------
    # Initialize Conda in the shell
    # ---------------------------------------------------------------------------
    RUN /opt/conda/bin/conda init bash
    
    # ---------------------------------------------------------------------------
    # Add Conda Environment Creation During Build
    # ---------------------------------------------------------------------------
    COPY environment.yml /tmp/environment.yml
    RUN /opt/conda/bin/conda env create -f /tmp/environment.yml -p /opt/conda/envs/openusd_env || true
    ENV PATH=/opt/conda/envs/openusd_env/bin:$PATH
    RUN echo "conda activate /opt/conda/envs/openusd_env" >> ~/.bashrc
    
    # ---------------------------------------------------------------------------
    # Set environment variables for USD (adjust paths as needed)
    # ---------------------------------------------------------------------------
    ENV PATH="/usr/local/OpenUSD/src:/usr/local/USD/bin:/opt/conda/envs/openusd_env/bin:/opt/conda/bin:/bin:/usr/bin:/usr/local/bin:${PATH}"
    ENV PYTHONPATH="/usr/local/USD/lib/python:${PYTHONPATH}"
    
    # ---------------------------------------------------------------------------
    # Default command: Interactive shell
    # ---------------------------------------------------------------------------
    CMD ["/bin/bash"]
    