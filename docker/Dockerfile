# ROCm ComfyUI Dockerfile
# Based on AMD's official ROCm PyTorch container

FROM ubuntu:latest

# Set working directory
WORKDIR /workspace

# Install system dependencies
RUN apt-get update && apt-get install -y \
  git \
  wget \
  curl \
  python3.12 \
  python3-pip \
  python3.12-venv \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Link Python binary
RUN ln -s /usr/bin/python3.12 /usr/bin/python

# Set up venv for Python
RUN python -m venv /opt/venv && source /opt/venv/bin/activate

# Clone ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git

# Set ComfyUI as working directory
WORKDIR /workspace/ComfyUI

# Create necessary directories with separate commands
RUN mkdir -p /workspace/ComfyUI/models/checkpoints && \
  mkdir -p /workspace/ComfyUI/models/diffusion_models && \
  mkdir -p /workspace/ComfyUI/models/text_encoders && \
  mkdir -p /workspace/ComfyUI/models/vae && \
  mkdir -p /workspace/ComfyUI/models/loras && \
  mkdir -p /workspace/ComfyUI/models/embeddings && \
  mkdir -p /workspace/ComfyUI/models/upscale_models && \
  mkdir -p /workspace/ComfyUI/models/controlnet && \
  mkdir -p /workspace/ComfyUI/output && \
  mkdir -p /workspace/ComfyUI/input && \
  mkdir -p /workspace/ComfyUI/custom_nodes

# Copy ROCm-tested constraints file
COPY docker/constraints.txt /workspace/

# Install ComfyUI dependencies with ROCm nightlies

RUN pip install --no-cache-dir \
  --pre torch torchaudio torchvision \
  --requirement /workspace/requirements.txt \
  --constraint /workspace/constraints.txt \
  --index-url https://rocm.nightlies.amd.com/v2/gfx1151/

# Copy startup script, models config, and sample workflow
COPY docker/startup.sh /workspace/startup.sh
COPY docker/download_models.py /workspace/download_models.py
COPY docker/models.yaml /workspace/models.yaml
COPY docker/sample_workflow.json /workspace/ComfyUI/

# Make startup script executable
RUN chmod +x /workspace/startup.sh

# Environment variables for model download behavior
# MODEL_DOWNLOAD options:
#   "default"   - Download basic SD 1.5 model (default)
#   "all"       - Download full model set (SD 1.5, SDXL, ControlNet, etc.)
#   "realistic" - Download realistic photo models  
#   "none"      - Skip all downloads, use existing models only
#   Custom      - Any section name from models.conf
ENV MODEL_DOWNLOAD=default

# Environment variables for ROCm behavior
# To do

# Expose ComfyUI port
EXPOSE 8188

# Health check to ensure ComfyUI is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8188/ || exit 1

# Use smart startup script that handles model downloads
CMD ["/workspace/startup.sh"]

