# Persistent Storage

## Por que usar volume persistente

Sem volume persistente, cada reinicio do Pod pode exigir:

- novo clone do ComfyUI;
- reinstalacao de dependencias;
- novo download de modelos;
- reinstalacao de custom nodes.

Isso aumenta custo de startup, risco operacional e tempo ate o servico ficar pronto.

## Onde salvar modelos

Diretorio recomendado:

```bash
/workspace/models/whisper
```

## Onde salvar custom nodes

Diretorio recomendado:

```bash
/workspace/ComfyUI/custom_nodes
```

## Como evitar download repetido do modelo

- Manter o volume persistente montado em `/workspace`.
- Configurar o custom node para procurar modelos em `/workspace/models`.
- Criar marcador local quando o download inicial depender de carregamento posterior.

## Como reduzir tempo de startup

- Reutilizar clone persistente do ComfyUI.
- Reutilizar dependencias previamente instaladas.
- Reutilizar custom nodes ja clonados.
- Evitar download repetido de `large-v2`.
