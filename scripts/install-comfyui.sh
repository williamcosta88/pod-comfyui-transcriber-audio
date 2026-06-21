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

install_ffmpeg_if_needed() {
  if command -v ffmpeg >/dev/null 2>&1; then
    log "ffmpeg already available in PATH"
    return 0
  fi

  if ! command -v apt-get >/dev/null 2>&1; then
    log "ERROR: ffmpeg is missing and apt-get is not available to install it automatically"
    exit 1
  fi

  if [[ "$(id -u)" -ne 0 ]]; then
    log "ERROR: ffmpeg is missing and automatic installation requires root privileges"
    exit 1
  fi

  log "ffmpeg not found. Installing with apt-get"
  apt-get update
  apt-get install -y ffmpeg

  if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "[install-comfyui] ERROR: ffmpeg was not installed or is not available in PATH"
    exit 1
  fi

  log "ffmpeg installed successfully"
}

log "ensuring workspace directory exists at $WORKSPACE_DIR"
mkdir -p "$WORKSPACE_DIR"

install_ffmpeg_if_needed

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
