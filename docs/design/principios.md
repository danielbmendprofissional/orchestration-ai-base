# Princípios de design deste projeto

Decisão fechada pro item "fluxo de design" do README: **code-first, sem Figma como etapa obrigatória** (Figma free-tier fica disponível como ferramenta pontual — ver seção final — mas nunca é um gate do fluxo). O design acontece dentro do próprio fluxo TDD+SDD (`docs/workflow.md`), na task de `ui` (`.pi/agents/ui.md`), com uma cadeia de ferramentas específica que substitui o que era só a skill `avoid-ai-design` na primeira versão deste documento.

## Por que mudou: uma skill sozinha não resolve ai-slop

A primeira versão deste fluxo usava só a skill `avoid-ai-design` (catálogo estático de P0/P1/P2 — ver `.claude/skills/avoid-ai-design/references/ai-tells-catalog.md`) rodando em modo `detect` sobre o diff. Isso continua válido como uma camada, mas é reativo: pega o "tell" óbvio depois que já foi escrito. A cadeia nova, replicando o workflow observado (ui-ux-pro-max-skill + impeccable.style), cobre as duas pontas — geração guiada por regras E auditoria automatizada contra o app rodando de verdade — e cobre Angular explicitamente (a `avoid-ai-design` original é focada em HTML/React).

## A cadeia de ferramentas, na ordem em que roda

### 1. `ui-ux-pro-max-skill` — geração do sistema de design inicial

Skill instalada globalmente (`nextlevelbuilder/ui-ux-pro-max-skill`, MIT, só Python stdlib) via plugin marketplace do Claude Code ou `uipro init --ai claude`. Cobre 22 frameworks incluindo Angular explicitamente. Funciona como motor de busca (BM25) sobre 192 categorias de produto, 79 estilos de UI, 192 paletas, 74 combinações de tipografia e 119 diretrizes de UX — ou seja, em vez de a task de `ui` "chutar" um estilo, ela consulta esse motor com o contexto da tela (ex: "dashboard B2B enterprise, denso, dark mode opcional") e recebe uma direção de design coerente e documentada.

**Importante, e isso o próprio autor da skill admite**: mesmo com essa direção coerente, a execução ainda pode cair em ai-slop (a escolha de paleta/tipografia é boa, mas a implementação do componente ainda pode reforçar clichê de framework). Por isso essa skill nunca é a etapa final — é sempre seguida pela auditoria abaixo.

### 2. `impeccable.style` — auditoria contra a app rodando de verdade

Instalado por projeto via `npx impeccable install` (Node 22.12+), integra com Claude Code via slash commands. Sequência exata, replicando o vídeo de referência do usuário:

1. `npx impeccable install` — uma vez por projeto.
2. `/impeccable init` — gera `DESIGN.md` (sistema visual, formato "Google Stitch") e `PRODUCT.md` (contexto de produto) na raiz do projeto. **Esses dois arquivos passam a ser a fonte de verdade viva do design daquele projeto específico** — `docs/design/tokens.md` deste template é só o ponto de partida/seed pra alimentar esse `init`, não o destino final (ver nota em `tokens.md`).
3. `/impeccable detect` rodando contra o `localhost` da aplicação já implementada (61 checagens determinísticas: contraste, espaçamento, hierarquia, "tell" de IA) — identifica ai-slop de verdade, olhando o DOM/CSS renderizado, não o código-fonte. Isso é o motivo de funcionar igual bem em Angular, React ou qualquer stack: a checagem é sobre o output visual, não sobre o framework.
4. Rodar os comandos que a própria ferramenta recomendar na saída do `detect` (variam por achado).
5. `/impeccable audit` — gera relatório completo + plano de correção.
6. Corrigir iterativamente usando `/impeccable adapt`, `/impeccable harden`, `/impeccable polish` (nessa ordem quando os três se aplicarem: adapt ajusta ao contexto, harden resolve robustez/estado de erro/acessibilidade, polish refina o acabamento visual).
7. Rodar `/impeccable audit` de novo pra confirmar que os achados foram resolvidos antes de fechar a task.

### 3. `avoid-ai-design` — segunda rede de segurança, mais rápida

Continua instalada (`.claude/skills/avoid-ai-design/`) e continua rodando em `/skill:avoid-ai-design detect` no `/code-review` final (`docs/workflow.md`). Papel agora é de checagem rápida e barata pro Claude Code confirmar no diff final, não a auditoria principal — essa passou a ser o `impeccable audit`. Mantém utilidade em specs pequenas/urgentes onde rodar a app localmente pro `impeccable detect` não compensa o custo.

## A regra central continua a mesma: default não escolhido é o "tell"

Um gradiente roxo-azul não é ruim porque roxo é ruim — é ruim porque ninguém escolheu, foi o reflexo do modelo. Vale pra fonte, espaçamento, ícone, cópia, e agora também pro tema default do PrimeNG (ver `component-library.md`).

### P0 — qualquer pessoa reconhece como "feito por IA"
- Gradiente roxo-pro-azul, texto com `bg-clip-text`
- Fonte `Inter`/`Roboto`/system default sem ter sido decisão de `tokens.md`
- Tema padrão do PrimeNG (Aura/Lara de fábrica) intocado
- Glassmorphism reflexivo
- Hero centralizado + três cards de feature ("template de SaaS genérico")

### P1 — dev/designer reconhece
- `rounded-2xl shadow-lg`/equivalente PrimeNG em toda superfície sem variação
- Ícone-dentro-de-quadrado-arredondado repetido
- Botão azul/indigo "de fábrica"
- Cópia tipo "Elevate your workflow", "Seamless", "Powerful" sem substância

## Perfil por tipo de tela

| Perfil | Como tratar |
|---|---|
| `dashboard` / `app-component` (o caso comum aqui: Angular enterprise/SaaS) | Passe cirúrgico: densidade, legibilidade e hierarquia de informação acima de decoração. |
| Landing/marketing (React, uso pontual) | Força total — direção visual ousada vale a pena. |
| Dentro de um design system já existente | Só cirúrgico, respeita os tokens que já existem. |

## Pesquisa de referência (antes de gerar, não só depois de auditar)

Duas ferramentas entram **antes** do passo 1, alimentando o que a task de `ui` pede pro `ui-ux-pro-max-skill`:

- **[interfaces.rauno.me](https://interfaces.rauno.me/)** — não é galeria de imagem, é checklist de boas práticas de interação (formulário, tipografia, motion, touch, performance, acessibilidade) com o porquê de cada regra. Usar como checklist de implementação, mesmo papel que o P0/P1/P2 acima, mas focado em comportamento/interação em vez de estética.
- **[lazyweb.com](https://www.lazyweb.com/)** — pesquisa de padrão via MCP (`lazyweb.com/mcp/public`), com base real de telas e testes A/B de produtos como Duolingo/Spotify/Airbnb. Consultar quando a task de `ui` precisar de um padrão específico já validado (ex: "como layouts de dashboard enterprise resolvem tabela densa + filtro").

Ver `referencias.md` pro catálogo completo de sites citados pelo usuário, incluindo os que servem só como inspiração visual (não ferramenta consultável por agente).

## Custo: onde gastar esforço e (Google AI Plus) cota antes de sair pagando mais

Ver `ferramentas-por-custo.md` — mapeia toda a cadeia acima (Claude Code, skills de Design/Dataviz do próprio Claude Code, Google AI Plus, ui-ux-pro-max-skill, impeccable, Figma) por camada de custo, com uma tabela de "preciso de X → uso Y primeiro". A regra curta: Camada 0 (já pago fixo, Claude Code) > Camada 1 (Google AI Plus, dentro da cota) > Camada 2 (gratuito fora de assinatura) > Camada 3 (custo extra — evitar sem necessidade clara).

## Figma (free tier, uso pontual)

Não é etapa do fluxo padrão. Fica disponível só pra quando um humano não-técnico precisar visualizar/discutir uma tela antes do código — nesse caso, tier gratuito é suficiente (poucos arquivos, sem necessidade de plano pago). Se usado, o resultado ainda passa pela cadeia acima quando virar código: Figma nunca substitui `impeccable detect` contra a app real.

## Fluxo prático (resumo operacional)

1. Task de `ui` lê `tokens.md`, `component-library.md` e este arquivo antes de qualquer classe/estilo.
2. Consulta `interfaces.rauno.me` (checklist) e `lazyweb` (MCP, se disponível no projeto) pra validar o padrão de interação antes de implementar.
3. Usa `ui-ux-pro-max-skill` pra obter a direção de design (paleta/tipografia/estilo coerente com o contexto da tela).
4. Implementa em Angular + PrimeNG, tema mapeado a partir de `tokens.md`.
5. Ao terminar, roda `/impeccable detect` contra o localhost do projeto (se já configurado) e resolve os achados com `/impeccable adapt|harden|polish`, depois `/impeccable audit` de confirmação.
6. Se `impeccable` ainda não estiver instalado no projeto (spec muito inicial), roda pelo menos `/skill:avoid-ai-design detect` como rede de segurança mínima antes de devolver a task.
7. No `/code-review` final do Claude Code, qualquer diff que toque UI roda `/skill:avoid-ai-design detect` de novo como segunda camada.
8. Acessibilidade não é opcional em nenhum perfil: `:focus-visible` ausente é sempre alta prioridade, mesmo fora do P0/P1/P2 — e em Angular isso é coberto também pela skill oficial `angular-developer` (seção ARIA/acessibilidade, ver `component-library.md`).
