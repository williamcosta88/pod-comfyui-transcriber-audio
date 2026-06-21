FROM nvidia/cuda:12.3.2-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV COMFYUI_DIR=/workspace/ComfyUI
ENV COMFYUI_PORT=8188
ENV COMFYUI_HOST=0.0.0.0
ENV MODELS_DIR=/workspace/models
ENV WHISPER_MODEL=large-v2
ENV COMFYUI_CUSTOM_NODES_DIR=/workspace/ComfyUI/custom_nodes

WORKDIR /workspace/runpod-pod-transcriber-audio

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    python3 \
    python3-pip \
    python3-venv \
    ffmpeg \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

COPY specs ./specs
COPY scripts ./scripts
COPY workflows ./workflows
COPY .env.example ./.env.example
COPY README.md ./README.md

RUN chmod +x ./scripts/*.sh \
  && mkdir -p /workspace /workspace/models /workspace/runpod-pod-transcriber-audio

EXPOSE 8188

CMD ["./scripts/start-comfyui.sh"]
