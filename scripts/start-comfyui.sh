#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[start-comfyui] %s\n' "$*"
}

COMFYUI_DIR="${COMFYUI_DIR:-/workspace/ComfyUI}"
COMFYUI_HOST="${COMFYUI_HOST:-0.0.0.0}"
COMFYUI_PORT="${COMFYUI_PORT:-8188}"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log "command not found: $1"
    exit 1
  fi
}

require_command python3

if [[ ! -f "$COMFYUI_DIR/main.py" ]]; then
  log "expected ComfyUI entrypoint not found at $COMFYUI_DIR/main.py"
  log "run ./scripts/install-comfyui.sh before starting the service"
  exit 1
fi

cd "$COMFYUI_DIR"
log "starting ComfyUI on $COMFYUI_HOST:$COMFYUI_PORT"
exec python3 main.py --listen "$COMFYUI_HOST" --port "$COMFYUI_PORT"
