# Atalhos para a toolchain em Docker. `make help` lista os alvos.
# Tudo que envolve Ruby roda no container; os alvos `su-*` falam com o
# SketchUp do Windows via interop do WSL (ver docs/workflow.md).

export HOST_UID := $(shell id -u)
export HOST_GID := $(shell id -g)

COMPOSE := docker compose
RUN     := $(COMPOSE) run --rm
SU_YEAR ?= 2026

.DEFAULT_GOAL := help
.PHONY: help build shell lint lint-fix test check package docs refdocs \
        lock clean su-launch su-debug su-loader su-eval su-ping su-testup vray-docs-import

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

## --- SketchUp no Windows (via WSL interop) --------------------------------

su-loader: ## Instala o loader de desenvolvimento no Plugins do SketchUp (SU_YEAR=2026)
	bash tools/sketchup/install-dev-loader.sh $(SU_YEAR)

su-launch: ## Abre o SketchUp (SU_YEAR=2026)
	bash tools/sketchup/launch.sh $(SU_YEAR)

su-debug: ## Abre o SketchUp com o debugger na porta 7150
	bash tools/sketchup/launch.sh $(SU_YEAR) --debug

su-ping: ## Verifica se a ponte de desenvolvimento está respondendo
	bash tools/sketchup/su-eval 'Sketchup.version'

su-eval: ## Executa Ruby no SketchUp aberto: make su-eval CODE='Sketchup.active_model.title'
	bash tools/sketchup/su-eval '$(CODE)'

su-testup: ## Roda tests/sketchup via TestUp CI (SketchUp fecha ao final)
	bash tools/sketchup/testup-ci.sh $(SU_YEAR)

vray-docs-import: ## Importa a doc da API Ruby do V-Ray instalada no Windows
	bash tools/docs/import-vray-docs.sh
