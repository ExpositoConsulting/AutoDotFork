# Use the official Python base image
FROM python:3.9-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive

# Install system dependencies and bash
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    gfortran \
    libopenblas-dev \
    liblapack-dev \
    libfftw3-dev \
    libpng-dev \
    libfreetype6-dev \
    pkg-config \
    wget \
    bash \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -a && \
    ln -s /opt/conda/bin/conda /usr/bin/conda

# Update PATH environment variable
ENV PATH /opt/conda/bin:$PATH

# Create a conda environment and install dependencies
RUN conda create -n demo_test python=3.6 && \
    conda install -n demo_test -c anaconda \
    scikit-image \
    scipy \
    numpy \
    matplotlib \
    && conda install -n demo_test -c conda-forge \
    pydoe \
    gpy \
    imageio \
    && conda clean -a

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Set PYTHONPATH to ensure the modules are found
ENV PYTHONPATH /app

# Activate conda environment and set entrypoint
SHELL ["conda", "run", "-n", "demo_test", "/bin/bash", "-c"]
ENTRYPOINT ["conda", "run", "-n", "demo_test", "--no-capture-output", "bash", "-c"]

CMD ["bash"]
