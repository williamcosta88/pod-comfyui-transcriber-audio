# Testing

## Testes manuais basicos

```bash
curl http://127.0.0.1:8188/system_stats
curl http://127.0.0.1:8188/object_info
curl -X POST http://127.0.0.1:8188/prompt -H "Content-Type: application/json" -d @workflows/whisper-large-v2.json
```

## Objetivo dos testes

- Confirmar que o servico HTTP do ComfyUI esta ativo.
- Confirmar que os objetos e nodes estao carregados.
- Confirmar que o workflow pode ser enfileirado.

## Teste de workflow com audio

Se houver um arquivo de audio real disponivel para o node `LoadAudio`, ajuste o JSON do workflow para apontar para um arquivo acessivel pelo ComfyUI antes do `POST /prompt`.

## Resultado esperado

- `/system_stats` retorna JSON.
- `/object_info` retorna JSON com informacoes dos nodes.
- `/prompt` retorna um identificador de job ou resposta equivalente do ComfyUI.

## Limites desta validacao

Sem custom nodes confirmados e sem GPU ativa no ambiente corrente, a validacao deste repositorio fica limitada a verificacao estrutural e documental. A execucao real deve ocorrer em ambiente Linux com GPU.
