# Troubleshooting

## Connection refused

Possiveis causas:

- ComfyUI nao iniciou.
- Porta `8188` nao esta exposta.
- Processo encerrou com erro durante bootstrap.

Verificacao:

```bash
./scripts/healthcheck.sh
```

## Timeout ao carregar large-v2

Possiveis causas:

- Primeiro carregamento do modelo.
- Download tardio realizado pelo custom node.
- GPU ou disco com throughput insuficiente.

Acao recomendada:

- aguardar o primeiro bootstrap;
- verificar volume persistente;
- confirmar disponibilidade de VRAM.

## FileNotFoundError: No such file or directory: 'ffmpeg'

Possivel causa:

- o pacote `ffmpeg` nao foi instalado no container ou nao esta disponivel no `PATH`.

Solucao:

```bash
apt-get update
apt-get install -y ffmpeg
```

Depois disso, valide:

```bash
which ffmpeg
ffmpeg -version
./scripts/install-comfyui.sh
./scripts/healthcheck.sh
```

## Modelo nao encontrado

Possiveis causas:

- caminho de modelos incorreto;
- volume nao montado;
- custom node configurado para outro diretorio.

## Custom node ausente

Possiveis causas:

- `WHISPER_NODE_REPO_URL` nao preenchido;
- clone nao realizado;
- dependencias do node nao instaladas.

## Falta de VRAM

Sintomas comuns:

- falha ao carregar `large-v2`;
- encerramento do processo;
- degradacao severa de performance.

Mitigacao:

- usar GPU com mais memoria;
- avaliar variacoes de modelo se o requisito operacional permitir.

## Porta nao exposta

Confirme na configuracao do Pod se a porta `8188` foi publicada para acesso externo quando necessario.

## Volume nao montado

Sem o volume em `/workspace`, o bootstrap pode:

- reinstalar tudo em cada reinicio;
- perder modelos;
- perder custom nodes;
- aumentar muito o tempo de readiness.

## ComfyUI iniciado antes da instalacao finalizar

Execute a sequencia recomendada:

```bash
./scripts/install-comfyui.sh
./scripts/install-custom-nodes.sh
./scripts/download-models.sh
./scripts/start-comfyui.sh
```
