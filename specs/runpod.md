# RunPod

## Como criar o Pod

1. Criar um Pod com imagem base compativel com CUDA.
2. Anexar um volume persistente para reter ComfyUI, modelos e custom nodes.
3. Montar o volume em `/workspace`.
4. Clonar este repositorio em `/workspace/runpod-pod-transcriber-audio`.
5. Expor a porta `8188` para acesso ao ComfyUI.

## GPU recomendada

Para o modelo Whisper `large-v2`, priorize GPUs com VRAM suficiente para evitar troca excessiva de memoria e lentidao operacional. Em termos praticos:

- Recomendado: GPUs com 16 GB de VRAM ou mais.
- Minimo operacional: depende do custom node e da estrategia de inferencia, mas abaixo disso ha risco maior de falha por memoria.

## Porta 8188

O ComfyUI deve ouvir em:

```bash
0.0.0.0:8188
```

No Pod, valide que a porta esta publicada externamente quando precisar acessar a UI fora do ambiente local.

## Uso de volume persistente

Monte um volume persistente em `/workspace` para preservar:

- `/workspace/ComfyUI`
- `/workspace/models`
- `/workspace/runpod-pod-transcriber-audio`

## Diretorios recomendados

- `/workspace/ComfyUI`
- `/workspace/models`
- `/workspace/runpod-pod-transcriber-audio`

## Como validar o Pod

Depois da instalacao e startup:

```bash
curl http://127.0.0.1:8188/system_stats
curl http://127.0.0.1:8188/object_info
```

Se ambos responderem, o Pod esta operacional do ponto de vista basico do ComfyUI.
