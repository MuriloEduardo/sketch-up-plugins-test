# Atalhos para a toolchain em Docker. `make help` lista os alvos.
# Tudo que envolve Ruby roda no container; os alvos `su-*` falam com o
# SketchUp do desktop Windows via Dev Bridge + túnel SSH (docs/remote-desktop-setup.md).

export HOST_UID := $(shell id -u)
export HOST_GID := $(shell id -g)

COMPOSE := docker compose
RUN     := $(COMPOSE) run --rm
SU_YEAR ?= 2026

.DEFAULT_GOAL := help
.PHONY: help build shell lint lint-fix test check package docs refdocs lock clean \
        dev-bridge-package su-connect su-install-bridge su-ping su-sync su-reload \
        su-eval su-test su-tunnel-stop vray-docs-import

help: ## Lista os alvos disponíveis
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

## --- Toolchain (Docker) ---------------------------------------------------

build: ## Constrói a imagem da toolchain
	$(COMPOSE) build dev

shell: ## Abre um shell no container
	$(RUN) dev bash

lint: ## RuboCop + RuboCop-SketchUp
	$(RUN) lint

lint-fix: ## RuboCop com autocorreção segura
	$(RUN) dev bundle exec rubocop -a

test: ## Testes unitários (fora do SketchUp)
	$(RUN) test

check: lint test ## lint + testes (rodar antes de commitar)

package: ## Gera dist/*.rbz
	$(RUN) package

docs: ## Gera documentação YARD em doc/
	$(RUN) docs

refdocs: ## Regenera docs/reference (precisa de rede)
	$(RUN) refdocs

lock: ## Atualiza Gemfile.lock dentro do container
	$(RUN) dev bundle lock --update

clean: ## Remove artefatos gerados
	rm -rf dist doc .yardoc .rubocop_cache

## --- SketchUp no desktop Windows (Dev Bridge via túnel SSH) --------------
# Guia: docs/remote-desktop-setup.md. Cliente: tools/devbridge/su (python3 do WSL).

SU := python3 tools/devbridge/su

dev-bridge-package: ## Gera dist/me_dev_bridge-*.rbz (extensão SÓ de desenvolvimento)
	$(RUN) dev ruby tools/build/package.rb tools/devbridge/extension

su-connect: ## Conecta ao desktop: make su-connect SSH=usuario@ip TOKEN=... KEY=~/.ssh/id [PORT=7860]
	$(SU) connect --ssh '$(SSH)' $(if $(PORT),--port $(PORT)) $(if $(KEY),--key '$(KEY)') $(if $(TOKEN),--token '$(TOKEN)') $(if $(SSH_PORT),--ssh-port $(SSH_PORT))

su-install-bridge: ## (chave modo full) Copia a Dev Bridge para o Plugins do desktop (SU_YEAR=2026)
	$(SU) install-bridge $(SU_YEAR)

su-ping: ## Testa a conexão com o SketchUp do desktop
	$(SU) ping

su-sync: ## Envia src/ e tests/sketchup/ para o desktop
	$(SU) sync

su-reload: su-sync ## Envia e recarrega as extensões no SketchUp
	$(SU) reload

su-eval: ## Executa Ruby no SketchUp: make su-eval CODE='Sketchup.active_model.title'
	$(SU) eval '$(CODE)'

su-test: su-sync ## Roda tests/sketchup com TestUp no desktop [FILTER=TC_Nome#]
	$(SU) test $(FILTER)

su-tunnel-stop: ## Fecha o túnel SSH
	$(SU) tunnel-stop

vray-docs-import: ## Baixa do desktop a doc oficial da API Ruby do V-Ray
	$(SU) pull-vray-docs
