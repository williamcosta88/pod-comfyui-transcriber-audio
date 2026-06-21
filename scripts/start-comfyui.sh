#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[start-comfyui] %s\n' "$*"
}

warn() {
  printf '[start-comfyui] WARNING: %s\n' "$*"
}

COMFYUI_DIR="${COMFYUI_DIR:-/workspace/ComfyUI}"
COMFYUI_HOST="${COMFYUI_HOST:-0.0.0.0}"
COMFYUI_PORT="${COMFYUI_PORT:-8188}"
MODELS_DIR="${MODELS_DIR:-/workspace/models}"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log "command not found: $1"
    exit 1
  fi
}

require_command python3
require_command curl

if [[ ! -d /workspace ]]; then
  warn "/workspace does not exist. Persistent storage may not be mounted."
fi

if [[ ! -f "$COMFYUI_DIR/main.py" ]]; then
  log "expected ComfyUI entrypoint not found at $COMFYUI_DIR/main.py"
  log "run ./scripts/install-comfyui.sh before starting the service"
  exit 1
fi

mkdir -p "$MODELS_DIR"

log "ComfyUI directory: $COMFYUI_DIR"
log "ComfyUI host: $COMFYUI_HOST"
log "ComfyUI port: $COMFYUI_PORT"
log "Models directory: $MODELS_DIR"

if command -v nvidia-smi >/dev/null 2>&1; then
  log "nvidia-smi detected. GPU inventory:"
  nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader || warn "nvidia-smi is present but failed to query GPU details"
else
  warn "nvidia-smi not found. This container may not have GPU runtime attached."
fi

python_cuda_diagnostics="$(python3 - <<'PY'
import json

details = {
    "torch_installed": False,
    "cuda_available": False,
    "device_count": 0,
    "device_name": "",
    "torch_version": "",
    "cuda_version": "",
    "error": "",
}

try:
    import torch

    details["torch_installed"] = True
    details["torch_version"] = getattr(torch, "__version__", "")
    details["cuda_version"] = getattr(torch.version, "cuda", "") or ""
    details["cuda_available"] = bool(torch.cuda.is_available())
    details["device_count"] = int(torch.cuda.device_count())
    if details["cuda_available"] and details["device_count"] > 0:
        details["device_name"] = torch.cuda.get_device_name(0)
except Exception as exc:
    details["error"] = str(exc)

print(json.dumps(details))
PY
)"

if [[ -z "$python_cuda_diagnostics" ]]; then
  warn "failed to collect Python CUDA diagnostics"
else
  log "Python CUDA diagnostics: $python_cuda_diagnostics"
  if [[ "$python_cuda_diagnostics" == *'"torch_installed": false'* ]]; then
    warn "PyTorch is not installed in the current Python environment"
  elif [[ "$python_cuda_diagnostics" == *'"cuda_available": false'* ]]; then
    warn "PyTorch is available but CUDA is not active. ComfyUI may run on CPU."
  else
    log "CUDA is available to PyTorch. ComfyUI should be able to use the GPU."
  fi
fi

if curl -fsS "http://127.0.0.1:${COMFYUI_PORT}/system_stats" >/dev/null 2>&1; then
  warn "port ${COMFYUI_PORT} already responds on /system_stats. Another ComfyUI instance may already be running."
fi

cd "$COMFYUI_DIR"
log "starting ComfyUI on $COMFYUI_HOST:$COMFYUI_PORT"
exec python3 main.py --listen "$COMFYUI_HOST" --port "$COMFYUI_PORT"
