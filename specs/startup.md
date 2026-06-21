# Startup

## Ordem de startup

1. Validar variaveis de ambiente.
2. Garantir que `/workspace/ComfyUI/main.py` existe.
3. Garantir que diretorios persistentes existam.
4. Iniciar o ComfyUI em `0.0.0.0:8188`.
5. Validar saude via `/system_stats`.

## Verificacao de dependencias

Antes de iniciar, confira:

- `python3` disponivel;
- `curl` disponivel para healthcheck;
- `main.py` presente em `/workspace/ComfyUI`;
- volume persistente montado em `/workspace`.
- disponibilidade de GPU via `nvidia-smi`, quando o Pod for configurado para GPU.

## Healthcheck em /system_stats

Endpoint esperado:

```bash
curl http://127.0.0.1:8188/system_stats
```

## Logs esperados

Durante o startup, os logs devem indicar:

- diretorio do ComfyUI encontrado;
- host e porta configurados;
- diagnostico de GPU/CUDA via `nvidia-smi` e `torch.cuda`;
- inicializacao do processo Python;
- disponibilidade subsequente dos endpoints HTTP.

## Como detectar falha de startup

Sinais comuns:

- `main.py` ausente;
- porta `8188` sem resposta;
- erro de importacao Python;
- `torch.cuda.is_available()` retornando `false` em um Pod que deveria usar GPU;
- falha ao carregar custom node;
- timeout prolongado ao inicializar modelo.
