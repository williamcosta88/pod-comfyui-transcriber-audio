#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[healthcheck] %s\n' "$*"
}

COMFYUI_PORT="${COMFYUI_PORT:-8188}"

if ! command -v curl >/dev/null 2>&1; then
  log "command not found: curl"
  exit 1
fi

log "checking ComfyUI health endpoint"
curl -fsS "http://127.0.0.1:${COMFYUI_PORT}/system_stats"
log "healthcheck succeeded"
