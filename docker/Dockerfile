# Toolchain de desenvolvimento da extensão SketchUp/V-Ray.
#
# O SketchUp 2024–2026 embarca Ruby 3.2.x, então o container usa a mesma
# versão para que RuboCop, testes unitários e YARD vejam a mesma linguagem que
# o SketchUp vai executar.
#
# O que roda aqui: lint, testes unitários (lógica pura), YARD, empacotamento
# .rbz e scripts de documentação. O que NÃO roda aqui: SketchUp e V-Ray (só
# Windows/macOS) — veja docs/workflow.md.
FROM ruby:3.2-slim-bookworm

ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential libyaml-dev git curl ca-certificates python3 unzip \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Instala as gems no build da imagem (camada cacheada enquanto Gemfile/lock
# não mudarem). Em runtime o repositório é montado por cima de /workspace.
COPY Gemfile Gemfile.lock* ./
RUN bundle install \
 && chmod -R a+rwX /usr/local/bundle

# Permite rodar como o UID/GID do host (ver compose.yaml) sem arquivos root.
ENV HOME=/tmp/home
RUN mkdir -p /tmp/home && chmod 1777 /tmp/home \
 && git config --system --add safe.directory /workspace

CMD ["bash"]
