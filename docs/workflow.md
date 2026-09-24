# Fluxo de trabalho

## Primeira configuração

No WSL (já feito no bootstrap):
```sh
make build        # imagem Docker da toolchain
make check        # lint + testes unitários
make package      # dist/*.rbz
```

No Windows (quando SketchUp/V-Ray estiverem instalados):
1. Instale SketchUp 2026 e V-Ray 7 (update 2+ para SketchUp 2026).
2. Abra o SketchUp uma vez (cria a pasta Plugins do usuário) e feche.
3. `make su-loader SU_YEAR=2026` — instala `me_dev_loader.rb` no Plugins,
   apontando para este repositório.
4. `make su-launch` e depois `make su-ping` → deve imprimir a versão.
5. Opcional: TestUp 2 (.rbz em github.com/SketchUp/testup-2/releases) para
   `make su-testup`.
6. `make vray-docs-import` — importa a doc oficial da API Ruby do V-Ray.
7. Se a política de carregamento de extensões do SketchUp bloquear código não
   assinado: Extension Manager › Loading Policy › "Unrestricted" (só na
   máquina de desenvolvimento).

## Ciclo diário

1. Editar código em `src/`.
2. `make check` (Docker) — rápido, sem SketchUp.
3. No SketchUp aberto: `make su-eval CODE='MuriloEduardoDev.reload'` para
   recarregar a implementação (arquivos de registro/menus exigem reiniciar).
4. Investigar/validar ao vivo: `make su-eval CODE='...'` ou
   `tools/sketchup/su-eval -f script.rb`.
5. `make su-testup` para os testes dentro do SketchUp.
6. Commit pequeno com mensagem descritiva.

## Depuração com breakpoints

`make su-debug` abre o SketchUp com o servidor DAP na porta 7150. No VS Code:
"Attach to SketchUp". A partir do WSL isso exige a rede do WSL em modo
*mirrored* (`.wslconfig`: `[wsl2] networkingMode=mirrored`) para que
`127.0.0.1:7150` alcance o Windows; alternativa: abrir o repositório no VS Code
do Windows via `\\wsl.localhost\...`. Detalhes e workarounds em
`tools/sketchup/debug/su_debug_bootstrap.rb`.

## Release

1. Atualizar `EXTENSION.version` no arquivo de registro (SemVer).
2. `make check && make package`.
3. Skill `sketchup-review-extension` (checklist de rejeições do EW).
4. Testar o `.rbz` instalando num SketchUp limpo (sem o loader de dev).
5. Enviar ao Extension Warehouse (não criptografar antes; o EW criptografa).

## Referência

Veja `docs/reference/README.md` para a ordem de consulta das fontes e
`make refdocs` para atualizar a base.
