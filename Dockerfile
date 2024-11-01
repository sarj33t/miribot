# Use Ubuntu as the base image
FROM ubuntu:20.04

# Set environment variable to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for building Python and required packages
RUN apt-get update && \
    apt-get install -y \
    wget \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libncurses5-dev \
    libreadline-dev \
    libgdbm-dev \
    libnss3-dev \
    libffi-dev \
    libsqlite3-dev \
    libbz2-dev \
    gcc \
    g++ \
    vim  \
    && rm -rf /var/lib/apt/lists/*

# Download and install Python 3.8 from source
RUN wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz && \
    tar -xf Python-3.8.0.tgz && \
    cd Python-3.8.0 && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make altinstall && \
    cd .. && \
    rm -rf Python-3.8.0 Python-3.8.0.tgz

# Install pip for Python 3.8 and upgrade pip/setuptools
RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3.8 get-pip.py && \
    rm get-pip.py && \
    python3.8 -m pip install --upgrade pip setuptools wheel

RUN python3.8 -m pip install spacy==3.5.0 chatterbot pyyaml flask chatterbot-corpus

RUN python3.8 -m spacy download en_core_web_sm

WORKDIR /app

COPY . .

EXPOSE 8000

CMD ["python3.8", "app.py"]


