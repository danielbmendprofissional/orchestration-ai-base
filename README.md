# ai-base

Projeto base para todo novo workflow assistido por IA — stack-agnóstico (nenhuma decisão de frontend/backend vive aqui). O que este repo fixa é o **processo**.

## O que tem aqui hoje

- `.claude/skills/` — 25 skills de engenharia (Matt Pocock / mattpocock/skills), cobrindo discovery, spec, tickets, TDD, review e apoio (debug, merge conflicts, retro, handoff). Todas exigem invocação explícita (`disable-model-invocation: true`), nenhuma dispara sozinha.
- `docs/workflow.md` — o pipeline completo: discovery → spec → tickets → TDD → review → commit → merge request → dev → (esteira) → qa → hml → master.
- `docs/agents/` — configuração das skills para este repo (issue tracker = GitLab via MCP a configurar por projeto, labels de triagem, layout de docs de domínio) e `orchestration.md` com a arquitetura de execução.
- `.pi/` — camada de execução: pi.dev com 7 subagents de papel (data, backend, front, ui, tests, security, review) em Deepseek V4 Flash / GPT-5.6 Luna, um `pi` por spec, 4 painéis em paralelo via Alethe.
- `pratices/tokens/` — configuração e benchmarks reais de economia de tokens (RTK sempre ligado; Caveman só em sessões Claude Code, nunca nos subagents de execução).
- `.claude/hooks/` — guardrail de git: bloqueia push direto em `main`/`master`/`dev`/`qa`/`hml`.
- `docs/design/` — Angular fixo como stack de frontend (PrimeNG + skills oficiais do Angular, `component-library.md`); cadeia anti-ai-slop `ui-ux-pro-max-skill` -> `impeccable.style` (`detect`/`audit`/`adapt`/`harden`/`polish`) -> `avoid-ai-design` como rede de segurança (`principios.md`); tokens de design seed (`tokens.md`); catálogo de sites de referência de UI/motion (`referencias.md`). `.claude/skills/avoid-ai-design/` audita/reescreve UI que caiu em padrão genérico de IA.
- `CLAUDE.md` — instruções de projeto para o Claude Code.

## Em aberto (próximas frentes, em ordem)

1. Instalar de verdade, na máquina real, a cadeia de design/frontend (skills do Angular, `ui-ux-pro-max-cli`, `impeccable`) — comandos em `docs/comandos-para-rodar.md`.
2. Branches protegidas + esteira de deploy no GitLab (SaaS).
3. Docker / Kubernetes + serviços de contexto (Redis, Postgres, RabbitMQ, Keycloak).

Ver `docs/workflow.md` para como usar o que já está pronto e `docs/comandos-para-rodar.md` para o setup local ainda pendente (instalar pi.dev, Alethe, glab).
