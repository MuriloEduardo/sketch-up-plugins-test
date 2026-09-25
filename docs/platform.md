# Plataforma: pilares, módulos e produtos

Proposta de 2026-09-24. Objetivo: começar pequeno em **vários produtos** sem
jogar nada fora. Tudo o que for construído agora é um pilar ou um módulo
reutilizável; "produto" é só uma **embalagem** de módulos.

## Ideia central

```
pilares (core)        módulos (funcionalidades)        produtos (.rbz)
──────────────        ─────────────────────────        ───────────────
kernel          ┐     scene_audit                ┐     ME Toolkit (beta, grátis)
modelo SketchUp │     material_variations        ├──►  = kernel + todos os módulos
V-Ray           ├──►  layout_sheets              │
jobs/fila       │     texture_relink             ┘     V-Ray Batch Studio (pago)
UI HtmlDialog   │     …                                = kernel + material_variations
LayOut/saídas   │                                          + turntable + fila
licença         ┘
```

- **Pilar**: código genérico, sem regra de produto (ex.: fila de tarefas
  assíncronas, janela HtmlDialog padrão, travessia do modelo).
- **Módulo**: uma funcionalidade pequena e completa (1 comando, 1 janela),
  que só usa pilares. Não depende de outro módulo.
- **Produto**: um manifesto (nome, namespace, versão, lista de módulos). O
  empacotador monta o `.rbz` copiando o core + os módulos escolhidos.

Assim o mesmo módulo pode estar no pacote grátis e num produto pago, e um
produto novo é só um manifesto novo.

### Por que copiar o core em cada produto (e não uma "extensão biblioteca")

O Extension Warehouse recomenda **duplicar a lógica compartilhada** em vez de
publicar uma extensão-biblioteca da qual as outras dependem
(`_cache/sketchup-api-guides/extension_requirements.md`, seção de
dependências). Se dois produtos nossos carregassem versões diferentes de um
mesmo `MuriloEduardo::Core`, um quebraria o outro. Por isso o empacotador
coloca o core **dentro do namespace de cada produto**
(`MuriloEduardo::<Produto>::Core`). No repositório existe uma cópia só.

## Pilares (ordem de construção)

| # | Pilar | Serve para | Roadmap |
|---|---|---|---|
| P0 | **Build multi-produto**: manifestos, cópia do core com namespace, versão, CI ✅ | todos | F1.9 |
| P1 | **Kernel**: registro de comandos + menu ✅, i18n pt-BR/en/es ✅, erros amigáveis ✅; depois: toolbar, menu de contexto, preferências | todos | F1.10 |
| P2 | **Modelo SketchUp**: travessia com transformações, seleção, tags, cenas, câmeras, materiais | auditoria, LayOut, variações | F1.5 |
| P3 | **V-Ray**: `VRayBridge` ampliado (settings, materiais, render, eventos), separando API documentada de interna | tudo que é V-Ray | F1.4 |
| P4 | **Jobs**: fila assíncrona com `UI.start_timer`, progresso, cancelamento, sem travar a UI; eventos de render | render em lote, exportações, LayOut | F1.6 |
| P5 | **UI**: uma janela HtmlDialog padrão (ponte Ruby↔JS, tema, i18n) | todos os módulos com janela | F1.7 |
| P6 | **Saídas**: LayOut (páginas, viewports, PDF), CSV, imagens | pranchas, relatórios | novo |
| P7 | **Licença/trial** (`Sketchup::Licensing`) | só quando existir o 1º pago | F1.8 |

Cada pilar nasce **puxado por um módulo real**, só com o necessário: nada de
framework especulativo.

## Primeiros módulos (mínimos, com demanda comprovada)

| Ordem | Módulo | Pilares que exercita | Por quê |
|---|---|---|---|
| 1 | `scene_audit`: relatório de texturas faltando/pesadas, materiais sem uso, versão do V-Ray | P1 P2 P3 P5 | só lê o modelo (risco zero), útil a todo usuário, isca grátis |
| 2 | `layout_sheets`: uma página do LayOut por cena, com carimbo, exporta PDF | P2 P4 P6 | pedido recorrente (fórum 236504); API validada ao vivo |
| 3 | `material_variations`: renderizar o mesmo enquadramento com N materiais | P3 P4 | dor citada no fórum da Chaos (118077); semente do Batch Studio |
| 4 | `texture_relink`: reencontrar texturas entre máquinas | P3 | Chaos 117780/119587 |

A Lilian usa SketchUp + V-Ray de verdade: é a **primeira usuária beta** do
pacote grátis.

## Distribuição e atualização

**Desenvolvimento (hoje):** não reinstala nada. `make su-reload` manda o
código novo para o SketchUp do desktop e recarrega. Só a própria Dev Bridge
precisa de `.rbz` novo quando ela muda, o que é raro.

**Clientes pelo Extension Warehouse (recomendado):** o EW cuida das
atualizações: publicamos a versão nova e o Extension Manager do usuário
oferece a atualização. Também traz vitrine, loja, licença e o selo de revisão.
O nosso `sketchup-dev-guide.md` lista "mecanismo próprio de atualização" como
proibido para o EW. A fonte dessa regra não está no cache, então é preciso
confirmar antes de decidir qualquer coisa que dependa disso.

**Venda direta (fora do EW), se um dia fizer sentido:** tecnicamente dá para
fazer um atualizador próprio (`Sketchup::Http::Request` para consultar a
versão num servidor + `Sketchup.install_from_archive` para instalar o `.rbz`).
Isso exige um servidor nosso e não vale para a versão do EW.

**O que evitar:** um "carregador fino" que baixa código Ruby da internet a
cada execução. Conflita com a revisão e a criptografia do EW (`.rbe`) e é um
risco de segurança para o cliente. Configuração remota (ligar e desligar
módulos, avisos) como **dados**, não como código, é aceitável e pode vir depois.

## Estrutura implementada (2026-09-24)

```
src/me_vray_toolkit/            produto completo = fonte única
  core/ sketchup/ vray/         pilares
  features/<nome>/              módulos (scene_audit, render_quality)
  product.rb                    NAME + FEATURES
products/<id>.json              produtos derivados (subconjunto de features)
tools/build/product_builder.rb  monta build/products/<id>/ e o package empacota
```

Diferença em relação à proposta inicial: em vez de uma pasta `platform/`
neutra gerando `src/`, o próprio `src/me_vray_toolkit/` é o produto completo.
Motivos: o `rubocop-sketchup` exige `src/` com arquivo de registro + pasta, e
a Dev Bridge continua sincronizando `src/` sem mudança (nada a reinstalar no
desktop). Produto derivado testado: lint do EW limpo no código gerado.
