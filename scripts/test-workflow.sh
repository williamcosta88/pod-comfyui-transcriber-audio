#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[test-workflow] %s\n' "$*"
}

COMFYUI_PORT="${COMFYUI_PORT:-8188}"
WORKFLOW_FILE="${WORKFLOW_FILE:-workflows/whisper-large-v2.json}"
TEST_AUDIO_FILE="${TEST_AUDIO_FILE:-}"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log "command not found: $1"
    exit 1
  fi
}

require_command curl

log "checking /system_stats"
curl -fsS "http://127.0.0.1:${COMFYUI_PORT}/system_stats" >/dev/null

log "checking /object_info"
curl -fsS "http://127.0.0.1:${COMFYUI_PORT}/object_info" >/dev/null

if [[ ! -f "$WORKFLOW_FILE" ]]; then
  log "workflow file not found: $WORKFLOW_FILE"
  exit 1
fi

if [[ -z "$TEST_AUDIO_FILE" ]]; then
  log "no TEST_AUDIO_FILE provided. Base connectivity checks passed."
  log "to enqueue a real transcription job, set TEST_AUDIO_FILE and update the workflow payload to reference an audio file accessible by ComfyUI."
  exit 0
fi

log "TEST_AUDIO_FILE was provided as $TEST_AUDIO_FILE"
log "ensure the workflow references this file before sending the request"
curl -fsS -X POST "http://127.0.0.1:${COMFYUI_PORT}/prompt" \
  -H "Content-Type: application/json" \
  --data @"$WORKFLOW_FILE"

log "workflow request submitted"
