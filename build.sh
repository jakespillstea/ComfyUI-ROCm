#!/bin/bash
# build.sh - Build ComfyUI ROCm Docker image

set -e

# Configuration
IMAGE_NAME="comfyui-rocm"
VERSION="${1:-latest}"
DETAILED_TAG="comfyui_0.3.43__rocm6.4.1_ubuntu24.04_py3.12_pytorch_2.6.0"

echo "🐳 Building ComfyUI ROCm Docker image..."
echo "📦 Tags: ${IMAGE_NAME}:${VERSION}, ${IMAGE_NAME}:${DETAILED_TAG}"
echo ""

# Build the image with both tags
echo "🔨 Building Docker image..."
docker build -f docker/Dockerfile -t "${IMAGE_NAME}:${VERSION}" -t "${IMAGE_NAME}:${DETAILED_TAG}" --progress=plain .
