# Whisper Workflow

## Workflow base

```text
LoadAudio -> Apply Whisper -> PreviewAny
```

## Nodes

### LoadAudio

Responsavel por carregar o arquivo de audio de entrada para o pipeline do ComfyUI.

### Apply Whisper

Responsavel por executar a transcricao usando Whisper, recebendo como entrada o audio e os parametros de inferencia.

### PreviewAny

Responsavel por exibir ou disponibilizar o texto resultante da transcricao para validacao.

## Configuracao padrao

- Modelo: `large-v2`
- Idioma: `Portuguese`
- Prompt: `Portugues do Brasil`

## Observacoes importantes

- A disponibilidade exata dos nodes depende dos custom nodes instalados.
- Caso o custom node realize download tardio do modelo, o primeiro processamento pode ser mais lento.
- O arquivo `workflows/whisper-large-v2.json` representa um contrato inicial e pode precisar de ajuste conforme o custom node confirmado.
