# Fluxo de trabalho

Duas máquinas:
- **Este PC (WSL)**: código, git, toolchain Docker, Claude Code.
- **Desktop Windows 11** na rede local: SketchUp Pro + V-Ray Pro, com a
  extensão de desenvolvimento **Dev Bridge**, acessada por túnel SSH.

## Primeira configuração

Toolchain (no WSL, já feito no bootstrap):
```sh
make build        # imagem Docker da toolchain
make check        # lint + testes unitários
make package      # dist/*.rbz
```

Desktop: siga [remote-desktop-setup.md](remote-desktop-setup.md) (OpenSSH,
chave, `make su-connect`, `make su-install-bridge`, TestUp 2).

## Ciclo diário

1. Editar código em `src/`.
2. `make check` (Docker): rápido, sem SketchUp.
3. No desktop: SketchUp aberto e *Extensions › Dev Bridge › Start*.
4. `make su-reload`: envia `src/` e `tests/sketchup/` e recarrega a implementação.
5. Investigar/validar ao vivo: `make su-eval CODE='...'` ou
   `tools/devbridge/su eval -f script.rb`.
6. `make su-test` para os testes dentro do SketchUp (TestUp).
7. Commit pequeno com mensagem descritiva. O CI (GitHub Actions) repete lint,
   testes e empacotamento a cada push.

## Depuração com breakpoints

Ainda não configurada no modelo de duas máquinas (item do backlog técnico).
O caminho previsto: `tools/debug/su_debug_bootstrap.rb` (template oficial,
porta 7150 em 127.0.0.1 no desktop), túnel SSH da porta 7150 e mapeamento de
caminhos workspace do desktop ↔ repositório. Enquanto isso, use `su eval`
para inspeção e `puts` temporário lido pelo `stdout` da resposta.

## Release

1. Atualizar `EXTENSION.version` no arquivo de registro (SemVer).
2. `make check && make package`.
3. Skill `sketchup-review-extension` (checklist de rejeições do EW).
4. Testar o `.rbz` num SketchUp **sem** a Dev Bridge (instale pelo Extension
   Manager): é o que o cliente vai receber.
5. Enviar ao Extension Warehouse (não criptografar antes; o EW criptografa).

## Referência

Veja `docs/reference/README.md` para a ordem de consulta das fontes e
`make refdocs` para atualizar a base.
