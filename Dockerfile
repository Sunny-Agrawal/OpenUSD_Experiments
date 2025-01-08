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
        nvidia-container-toolkit \
        libglu-dev libxinerama-dev libxcursor-dev libxi-dev \
        libxrandr-dev libx11-dev \
        libtbb-dev \
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

    # Initialize Conda and ensure .bashrc is sourced in future sessions
    RUN echo ". /opt/conda/etc/profile.d/conda.sh && conda activate /opt/conda/envs/openusd_env" >> ~/.bashrc
    
    # ---------------------------------------------------------------------------
    # Copy Entrypoint Script and Make It Executable
    # ---------------------------------------------------------------------------
    COPY entrypoint.sh /usr/local/bin/entrypoint.sh
    RUN chmod +x /usr/local/bin/entrypoint.sh
    
    # ---------------------------------------------------------------------------
    # Use Entrypoint Script and Default Command
    # ---------------------------------------------------------------------------
    ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
    CMD ["/bin/bash"]
    