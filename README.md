# runpod-pod-transcriber-audio

Projeto de infraestrutura para preparar e executar o ComfyUI com suporte a transcricao de audio via Whisper em um Pod da RunPod com GPU. Este repositorio segue Spec-Driven Design e separa claramente especificacao, implementacao e validacao operacional.

## Visao geral

O objetivo e disponibilizar uma base de producao para subir apenas o ComfyUI e seus componentes de suporte. O fluxo alvo de transcricao e:

```text
LoadAudio -> Apply Whisper -> PreviewAny
```

O servico principal roda em `0.0.0.0:8188` e sera consumido futuramente por um gateway Node.js separado, fora do escopo deste projeto.

## Pre-requisitos

- Pod RunPod com suporte a GPU
- Volume persistente montado em `/workspace`
- Linux com `bash`, `git`, `curl`, `python3` e `apt-get`
- Acesso de rede para clonar o ComfyUI e baixar dependencias
- URLs confirmadas dos custom nodes, se necessario

## Estrutura

```text
runpod-pod-transcriber-audio/
|-- specs/
|-- scripts/
|-- workflows/
|-- Dockerfile
|-- docker-compose.yml
|-- .env.example
`-- README.md
```

## Processo orientado por specs

Antes de qualquer ajuste operacional, siga o roteiro em `specs/tasks.md`. As especificacoes detalhadas ficam em:

- `specs/README.md`
- `specs/architecture.md`
- `specs/runpod.md`
- `specs/comfyui-installation.md`
- `specs/whisper-workflow.md`
- `specs/persistent-storage.md`
- `specs/startup.md`
- `specs/testing.md`
- `specs/troubleshooting.md`

## Como instalar no Pod

1. Monte o volume persistente em `/workspace`.
2. Clone este repositorio em `/workspace/runpod-pod-transcriber-audio`.
3. Ajuste as variaveis do arquivo `.env.example` conforme necessario.
4. O projeto ja vem com `WHISPER_NODE_REPO_URL=https://github.com/yuvraj108c/ComfyUI-Whisper` como repositorio padrao do custom node Whisper.
5. Execute:

```bash
chmod +x scripts/*.sh
./scripts/install-comfyui.sh
./scripts/install-custom-nodes.sh
./scripts/download-models.sh
```

O `install-comfyui.sh` garante a presenca do `ffmpeg`, instala o pacote automaticamente via `apt-get` quando necessario e falha cedo se o binario nao puder ser disponibilizado no `PATH`.

## Como rodar

Para iniciar o ComfyUI:

```bash
./scripts/start-comfyui.sh
```

Isso executa:

```bash
python3 main.py --listen 0.0.0.0 --port 8188
```

Antes de iniciar o processo principal, o script tambem registra diagnosticos do ambiente, incluindo verificacao de `nvidia-smi`, status de `torch.cuda` e alerta caso o container esteja prestes a rodar em CPU.

## Como testar

Validacao basica:

```bash
which ffmpeg
ffmpeg -version
./scripts/healthcheck.sh
curl http://127.0.0.1:8188/object_info
```

Validacao do workflow:

```bash
./scripts/test-workflow.sh
```

Se quiser submeter um audio real, ajuste `workflows/whisper-large-v2.json` para um arquivo acessivel ao ComfyUI e forneca `TEST_AUDIO_FILE` no ambiente.

## Como expor a porta no RunPod

Exponha a porta `8188` na configuracao do Pod. Internamente, o gateway futuro deve preferir `http://127.0.0.1:8188` para comunicacao local no mesmo Pod.

## Como usar volume persistente

Mantenha os seguintes diretorios no volume:

- `/workspace/ComfyUI`
- `/workspace/models`
- `/workspace/ComfyUI/custom_nodes`

Isso evita reinstalacao e download repetido de modelos.

## Estrategia de imagem Docker

O `Dockerfile` instala dependencias de sistema e copia scripts, specs e workflows, mas nao embute o checkout completo do ComfyUI na imagem. A estrategia escolhida e instalar o ComfyUI no volume persistente via `install-comfyui.sh`, reduzindo tamanho da imagem e favorecendo reaproveitamento entre reinicios do Pod.

## Integracao futura com Node.js gateway

Este projeto prepara o contrato minimo esperado para um gateway futuro:

- `GET http://127.0.0.1:8188/system_stats`
- `GET http://127.0.0.1:8188/object_info`
- `POST http://127.0.0.1:8188/prompt`

O payload base de transcricao esta em `workflows/whisper-large-v2.json`.

## Troubleshooting rapido

- `Connection refused`: confirme se `start-comfyui.sh` foi executado com sucesso.
- `FileNotFoundError: [Errno 2] No such file or directory: 'ffmpeg'`: execute `apt-get update && apt-get install -y ffmpeg` e rode `./scripts/install-comfyui.sh` novamente.
- `Model not found`: confirme o volume montado e o caminho `/workspace/models/whisper`.
- `Custom node ausente`: confirme se o clone de `https://github.com/yuvraj108c/ComfyUI-Whisper` foi concluido corretamente.
- `Falta de VRAM`: priorize GPU com 16 GB ou mais para `large-v2`.
- `Porta nao exposta`: revise a configuracao do Pod na RunPod.

## Observacoes importantes

- Nenhum gateway Node.js foi implementado neste repositorio.
- O repositorio padrao do custom node Whisper configurado neste projeto e `https://github.com/yuvraj108c/ComfyUI-Whisper`.
