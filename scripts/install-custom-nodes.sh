#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[install-custom-nodes] %s\n' "$*"
}

COMFYUI_DIR="${COMFYUI_DIR:-/workspace/ComfyUI}"
COMFYUI_CUSTOM_NODES_DIR="${COMFYUI_CUSTOM_NODES_DIR:-$COMFYUI_DIR/custom_nodes}"
WHISPER_NODE_REPO_URL="${WHISPER_NODE_REPO_URL:-https://github.com/yuvraj108c/ComfyUI-Whisper}"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log "command not found: $1"
    exit 1
  fi
}

clone_if_configured() {
  local repo_url="$1"
  local target_dir="$2"
  local label="$3"

  if [[ -z "$repo_url" ]]; then
    log "$label repository URL not configured. Fill the matching environment variable before installing this node."
    return 0
  fi

  if [[ -d "$target_dir/.git" ]]; then
    log "$label already installed at $target_dir"
    return 0
  fi

  if [[ -d "$target_dir" && ! -d "$target_dir/.git" ]]; then
    log "target directory $target_dir exists but is not a git repository"
    exit 1
  fi

  log "cloning $label from $repo_url into $target_dir"
  git clone "$repo_url" "$target_dir"
}

require_command git
require_command python3

if [[ ! -f "$COMFYUI_DIR/main.py" ]]; then
  log "ComfyUI not found at $COMFYUI_DIR. Run install-comfyui.sh first."
  exit 1
fi

mkdir -p "$COMFYUI_CUSTOM_NODES_DIR"
log "ensured custom nodes directory exists at $COMFYUI_CUSTOM_NODES_DIR"

# The default repository below is the configured Whisper custom node source.
# Override WHISPER_NODE_REPO_URL only if you intentionally need a different
# confirmed repository in your environment.
clone_if_configured "$WHISPER_NODE_REPO_URL" "$COMFYUI_CUSTOM_NODES_DIR/whisper-node" "whisper node"

for node_dir in "$COMFYUI_CUSTOM_NODES_DIR/whisper-node"; do
  if [[ -f "$node_dir/requirements.txt" ]]; then
    log "installing Python requirements for $node_dir"
    python3 -m pip install -r "$node_dir/requirements.txt"
  fi
done

log "custom node installation step completed"
