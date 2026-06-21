# Specs - runpod-pod-transcriber-audio

## Objetivo do projeto

Este projeto define, documenta e automatiza a preparacao de um ambiente de producao para executar o ComfyUI com suporte a transcricao de audio usando Whisper dentro de um Pod da RunPod com GPU.

## O que este projeto faz

- Provisiona a base documental para uma instalacao orientada por especificacao.
- Automatiza a instalacao do ComfyUI em armazenamento persistente.
- Prepara o ambiente para custom nodes de audio e Whisper.
- Organiza o armazenamento persistente de modelos e artefatos do ComfyUI.
- Fornece scripts de startup, healthcheck e validacao operacional.
- Define um workflow base de transcricao `LoadAudio -> Apply Whisper -> PreviewAny`.

## O que este projeto nao faz

- Nao implementa gateway Node.js.
- Nao expoe API publica propria alem da interface e endpoints nativos do ComfyUI.
- Nao fixa URLs de custom nodes sem confirmacao explicita.
- Nao orquestra criacao automatica do Pod na RunPod por API.

## Fluxo geral da transcricao

1. Um arquivo de audio e disponibilizado ao workflow.
2. O node `LoadAudio` carrega o audio.
3. O node `Apply Whisper` processa o audio com o modelo `large-v2`.
4. O node `PreviewAny` exibe o texto transcrito para inspecao.

## Relacao futura com o gateway Node.js

No desenho alvo da plataforma, este projeto sera a camada local de inferencia e processamento de audio. Um gateway Node.js futuro rodando no mesmo Pod consumira o ComfyUI via `http://127.0.0.1:8188`, principalmente pelos endpoints `/prompt`, `/system_stats` e `/object_info`.

Este repositorio existe para entregar uma base solida, observavel e operacional do ComfyUI. O gateway fica deliberadamente fora do escopo.
