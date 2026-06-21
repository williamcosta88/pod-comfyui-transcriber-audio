# ComfyUI Installation

## Estrategia adotada

O ComfyUI sera instalado no volume persistente em `/workspace/ComfyUI` por script. Essa abordagem reduz o tamanho da imagem, facilita upgrades e evita reinstalacoes completas quando o Pod reinicia.

## Instalar ComfyUI

Script responsavel:

```bash
./scripts/install-comfyui.sh
```

Fluxo esperado:

1. Garantir que `/workspace` exista.
2. Instalar `ffmpeg` automaticamente via `apt-get` quando o binario ainda nao estiver disponivel.
3. Validar a presenca de `ffmpeg` no `PATH`.
4. Clonar o repositorio do ComfyUI em `/workspace/ComfyUI` se ainda nao existir.
5. Validar a presenca de `/workspace/ComfyUI/main.py`.
6. Instalar dependencias Python a partir de `requirements.txt`.

## Instalar dependencias Python

O script usa `python3 -m pip install --upgrade pip` e `python3 -m pip install -r requirements.txt`. Dependencias adicionais especificas de custom nodes devem ser instaladas depois, quando os repositorios corretos estiverem configurados.

## Instalar ffmpeg

O workflow de audio e o custom node Whisper dependem do comando `ffmpeg` para carregar e processar arquivos de audio. Por isso o bootstrap inclui uma etapa explicita equivalente a:

```bash
apt-get update
apt-get install -y ffmpeg
```

Depois da instalacao, o script valida o binario com `command -v ffmpeg` e interrompe o processo se o comando continuar indisponivel.

## Instalar custom nodes

Script responsavel:

```bash
./scripts/install-custom-nodes.sh
```

O script cria o diretorio `custom_nodes`, mas nao inventa URLs. Os repositorios devem ser informados via:

```bash
WHISPER_NODE_REPO_URL=https://github.com/yuvraj108c/ComfyUI-Whisper
```

Este projeto usa `https://github.com/yuvraj108c/ComfyUI-Whisper` como repositorio padrao do custom node Whisper. Se o repositorio Whisper tambem fornecer os nodes de carregamento de audio usados no workflow, ele deve ser a unica fonte configurada aqui.

## Configurar ambiente para GPU

- Utilizar imagem base com CUDA.
- Garantir drivers e runtime GPU suportados pela plataforma RunPod.
- Executar o container com suporte a GPU.
- Validar que as bibliotecas Python usadas pelo ComfyUI estejam compativeis com a GPU disponivel.

## Iniciar o ComfyUI

Comando padrao:

```bash
python main.py --listen 0.0.0.0 --port 8188
```

O script `./scripts/start-comfyui.sh` encapsula essa inicializacao com validacoes previas.
