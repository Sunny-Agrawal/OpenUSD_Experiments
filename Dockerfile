# ---------------------------------------------------------------------------
# Base Image: Ubuntu with CUDA for GPU acceleration (adjust CUDA version as needed)
# ---------------------------------------------------------------------------
    FROM nvidia/cuda:12.0.1-devel-ubuntu22.04

    # ---------------------------------------------------------------------------
    # Install basic dependencies
    # ---------------------------------------------------------------------------
    RUN apt-get update && apt-get install -y \
        build-essential \
        cmake \
        git \
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
        /opt/conda/bin/conda clean -tipsy
    ENV PATH=/opt/conda/bin:$PATH
    
    # ---------------------------------------------------------------------------
    # Copy Conda environment and install dependencies
    # ---------------------------------------------------------------------------
    COPY environment.yml /tmp/environment.yml
    RUN conda env create -f /tmp/environment.yml && conda clean -a
    RUN echo "conda activate openusd_env" >> ~/.bashrc
    ENV CONDA_DEFAULT_ENV=openusd_env
    ENV PATH="/opt/conda/envs/openusd_env/bin:$PATH"
    
    # ---------------------------------------------------------------------------
    # Set environment variables for USD
    # ---------------------------------------------------------------------------
    ENV PATH="/usr/local/USD/bin:${PATH}"
    ENV PYTHONPATH="/usr/local/USD/lib/python:${PYTHONPATH}"
    
    # ---------------------------------------------------------------------------
    # Default command: Interactive shell
    # ---------------------------------------------------------------------------
    CMD ["/bin/bash"]
    