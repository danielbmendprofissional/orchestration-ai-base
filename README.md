# ai-base

Projeto base para todo novo workflow assistido por IA — stack-agnóstico (nenhuma decisão de frontend/backend vive aqui). O que este repo fixa é o **processo**.

## O que tem aqui hoje

- `.claude/skills/` — 25 skills de engenharia (Matt Pocock / mattpocock/skills), cobrindo discovery, spec, tickets, TDD, review e apoio (debug, merge conflicts, retro, handoff).
- `docs/workflow.md` — o pipeline completo: discovery → spec → tickets → TDD → review → commit → merge request → branch protegida.
- `docs/agents/` — configuração das skills para este repo (issue tracker = GitLab, labels de triagem, layout de docs de domínio).
- `pratices/tokens/` — configuração e benchmarks reais de economia de tokens (RTK, Caveman).
- `CLAUDE.md` — instruções de projeto para o Claude Code.

## Em aberto (próximas frentes)

- Arquitetura de 4 agentes pais + subagents (pi.dev / pi-agent-orchestrator) e como plugar Deepseek V4 Flash e GPT-5.6 Luna nela.
- Fluxo de design (sem ai-slop, melhor custo-benefício).
- Branches protegidas + esteira de deploy no GitLab (SaaS).
- Docker / Kubernetes + serviços de contexto (Redis, Postgres, RabbitMQ, Keycloak).

Ver `docs/workflow.md` para como usar o que já está pronto.
