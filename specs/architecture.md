# Architecture

## Visao geral

```text
RunPod Pod
|-- ComfyUI :8188
|-- Custom nodes de audio/Whisper
|-- Modelos Whisper em volume persistente
`-- Futuro gateway Node.js :3000
```

Este projeto sobe apenas a camada ComfyUI e seus componentes de suporte. O gateway Node.js aparece somente como consumidor futuro e nao faz parte da implementacao deste repositorio.

## Componentes

### RunPod Pod

Unidade de execucao com GPU, disco persistente e exposicao de portas. O Pod hospeda o runtime de inferencia, os modelos e a aplicacao ComfyUI.

### ComfyUI

Servico principal exposto na porta `8188`, iniciado com `python main.py --listen 0.0.0.0 --port 8188`. Ele entrega a interface, a API local e a execucao dos workflows.

### Custom nodes de audio e Whisper

Extensoes necessarias para disponibilizar os nodes `LoadAudio`, `Apply Whisper` e `PreviewAny`, ou equivalentes do workflow escolhido. O projeto usa como repositorio padrao do custom node Whisper `https://github.com/yuvraj108c/ComfyUI-Whisper`.

### Armazenamento persistente

O volume persistente concentra:

- `/workspace/ComfyUI`
- `/workspace/models`
- `/workspace/ComfyUI/custom_nodes`

Isso reduz tempo de bootstrap, evita reinstalacoes e preserva modelos entre reinicios do Pod.

### Gateway Node.js futuro

O gateway planejado rodara no mesmo Pod, preferencialmente em `:3000`, chamando o ComfyUI via loopback local. Este contrato futuro depende da disponibilidade minima dos endpoints:

- `GET /system_stats`
- `GET /object_info`
- `POST /prompt`

## Requisitos nao funcionais

- Escalabilidade vertical por GPU mais VRAM.
- Observabilidade basica por logs e healthcheck HTTP.
- Idempotencia dos scripts de instalacao.
- Reutilizacao de armazenamento persistente.
- Operacao segura com validacoes e falha rapida.
