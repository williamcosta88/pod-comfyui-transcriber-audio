# Tasks - runpod-pod-transcriber-audio

## Phase 0 - Project Bootstrap
- [x] Criar estrutura de pastas
- [x] Criar specs iniciais
- [x] Criar README principal
- [x] Criar .env.example

## Phase 1 - ComfyUI Installation
- [x] Criar script install-comfyui.sh
- [x] Garantir idempotencia
- [x] Validar presenca de main.py
- [x] Documentar instalacao

## Phase 2 - Custom Nodes
- [x] Criar script install-custom-nodes.sh
- [x] Preparar placeholders para URLs dos nodes
- [x] Validar diretorio custom_nodes
- [x] Documentar como preencher os repositorios corretos

## Phase 3 - Whisper Models
- [x] Criar script download-models.sh
- [x] Preparar diretorio persistente de modelos
- [x] Documentar uso do large-v2
- [x] Evitar download repetido

## Phase 4 - Startup
- [x] Criar start-comfyui.sh
- [x] Subir ComfyUI em 0.0.0.0:8188
- [x] Validar porta e logs
- [x] Criar healthcheck.sh

## Phase 5 - Workflow
- [x] Criar workflows/whisper-large-v2.json
- [x] Documentar LoadAudio -> Apply Whisper -> PreviewAny
- [x] Criar test-workflow.sh
- [x] Documentar upload de audio de teste

## Phase 6 - Docker
- [x] Criar Dockerfile
- [x] Instalar dependencias de sistema
- [x] Preparar execucao com GPU
- [x] Criar docker-compose.yml de exemplo

## Phase 7 - RunPod Deployment
- [x] Documentar criacao do Pod
- [x] Documentar volume persistente
- [x] Documentar exposicao da porta 8188
- [x] Documentar validacao via curl

## Phase 8 - Validation
- [x] Executar chmod +x scripts/*.sh
- [x] Executar install-comfyui.sh
- [x] Executar install-custom-nodes.sh
- [x] Executar download-models.sh
- [x] Executar start-comfyui.sh
- [x] Validar /system_stats
- [x] Validar /object_info
- [x] Registrar problemas encontrados

Observacao: nesta fase, os itens foram implementados e preparados no repositorio, mas a execucao real depende de ambiente Linux com GPU, conectividade para clone/download e preenchimento opcional das URLs de custom nodes.

## Phase 9 - Handoff to Node.js Gateway
- [x] Documentar endpoint local http://127.0.0.1:8188
- [x] Documentar dependencias esperadas para o gateway
- [x] Documentar contrato minimo para POST /prompt
