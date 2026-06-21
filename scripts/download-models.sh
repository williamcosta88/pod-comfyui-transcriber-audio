#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[download-models] %s\n' "$*"
}

MODELS_DIR="${MODELS_DIR:-/workspace/models}"
WHISPER_MODEL="${WHISPER_MODEL:-large-v2}"
WHISPER_MODELS_DIR="$MODELS_DIR/whisper"
MODEL_MARKER="$WHISPER_MODELS_DIR/${WHISPER_MODEL}.placeholder"

mkdir -p "$WHISPER_MODELS_DIR"
log "ensured whisper model directory exists at $WHISPER_MODELS_DIR"

if [[ -f "$MODEL_MARKER" ]]; then
  log "model placeholder already exists for $WHISPER_MODEL, skipping duplicate preparation"
  exit 0
fi

cat >"$MODEL_MARKER" <<EOF
This project is prepared to use the Whisper model: $WHISPER_MODEL

If your chosen ComfyUI custom node downloads Whisper models automatically,
the first workflow execution may populate this directory on demand.

Keep this directory on persistent storage to avoid repeated downloads.
EOF

log "created model placeholder at $MODEL_MARKER"
log "if your confirmed custom node supports explicit prefetch, extend this script with the node's documented download command"
