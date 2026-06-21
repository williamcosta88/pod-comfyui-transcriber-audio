#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[install-comfyui] %s\n' "$*"
}

COMFYUI_DIR="${COMFYUI_DIR:-/workspace/ComfyUI}"
COMFYUI_REPO_URL="${COMFYUI_REPO_URL:-https://github.com/comfyanonymous/ComfyUI.git}"
WORKSPACE_DIR="$(dirname "$COMFYUI_DIR")"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log "command not found: $1"
    exit 1
  fi
}

require_command git
require_command python3

log "ensuring workspace directory exists at $WORKSPACE_DIR"
mkdir -p "$WORKSPACE_DIR"

if [[ -d "$COMFYUI_DIR/.git" ]]; then
  log "existing ComfyUI repository found at $COMFYUI_DIR, skipping clone"
elif [[ -d "$COMFYUI_DIR" && ! -f "$COMFYUI_DIR/main.py" ]]; then
  log "directory $COMFYUI_DIR exists but does not look like a valid ComfyUI checkout"
  exit 1
else
  log "cloning ComfyUI into $COMFYUI_DIR"
  git clone "$COMFYUI_REPO_URL" "$COMFYUI_DIR"
fi

if [[ ! -f "$COMFYUI_DIR/main.py" ]]; then
  log "expected file not found: $COMFYUI_DIR/main.py"
  exit 1
fi

log "installing python dependencies"
cd "$COMFYUI_DIR"
python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt

log "ComfyUI installation completed successfully"
