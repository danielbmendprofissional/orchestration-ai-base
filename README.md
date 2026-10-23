# ai-base

Projeto base pra todo novo workflow assistido por IA — vira o `<projeto>-workspace` de cada projeto (ver `docs/agents/workspace.md`) — stack-agnóstico no backend, Angular fixo no frontend. O que este repo fixa é o **processo**: discovery → spec → tickets → TDD → review → commit → merge request → esteira de deploy.

## Por onde começar

- Ideal utilizar o agent de infra do `ai-ops` (`local-environment-config`) pra configuração de máquina e configuração inicial de projeto; depois, com tudo configurado, inicia o workflow com o Claude Code.

## Estrutura do repo

- `CLAUDE.md` — instruções de projeto pro Claude Code.
- `README.md` — este arquivo.
- `docs/workflow.md` — o pipeline completo, discovery → esteira de deploy.

### `docs/agents/` — skills e regras de execução

- `orchestration.md` — orquestração `pi.dev` + Alethe (subagents `data`/`backend`/`front`/`ui`/`tests`/`security`/`review`, execução paralela).
- `workspace.md` — padrão de projeto: workspace (regras + issues) + um repositório por componente (`-api`, `-frontend`).
- `esteira-deploy.md` — promoção de branch `dev → qa → hml → main`, hotfix.
- `infra-local.md` — modelo de infra compartilhada (Postgres/Redis/RabbitMQ/Keycloak), o que todo projeto novo ganha nela, e as diferenças pra produção (AWS).
- `observabilidade-backup.md` — `/health`, `/metrics`, log JSON, backup de Postgres.
- `security-review.md` — camadas de segurança, skills de auditoria manual, fluxo de correção de achado.
- `issue-tracker.md` — GitLab MCP / fallback `glab` pra issues e specs.
- `triage-labels.md` — vocabulário fixo de labels (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`).
- `domain.md` — como `/domain-modeling` decide contextos, `CONTEXT.md`/`CONTEXT-MAP.md`, ADRs.

### `docs/design/` — stack de UI fixa (Angular + spartan/ui + Tailwind)

- `component-library.md` — biblioteca de componentes por stack, motion, regra de tema custom obrigatório.
- `tokens.md` — tokens de design (cor, tipografia, espaçamento, raio/sombra, movimento) como ponto de partida pro `DESIGN.md` gerado por `impeccable`.
- `principios.md` — cadeia anti-ai-slop (`ui-ux-pro-max-skill` + `impeccable.style` + `avoid-ai-design`).
- `referencias.md` — catálogo de sites de referência visual (Aceternity UI, 21st.dev, bklit UI) e o papel de cada um.

### `docs/adr/`

Vazio por padrão — cada projeto real registra suas próprias decisões de arquitetura aqui conforme nascem, não é pré-populado pelo template.

### Fora de `docs/`

- `.claude/skills/` — **não versionado** (ver `.gitignore`): skills reinstaláveis por comando, não commitadas. `skills-lock.json` (esse sim versionado) registra origem e hash de cada uma, pra reinstalar de forma reprodutível.
- `.claude/hooks/` — guardrail de git (bloqueia push direto em branch protegida, force push, reset hard, etc — só vale pra sessão Claude Code).
- `.pi/` — camada de execução: subagents de papel (data, backend, front, ui, tests, security, review) rodando via pi.dev.
- `.mcp.json` — MCP do projeto (bloco GitLab sempre, GitHub sob demanda), sempre `"disabled": true`.
- `templates/` — `.gitlab-ci.yml` dos repositórios de código (`api.gitlab-ci.yml`, `frontend.gitlab-ci.yml`), consumindo o `template-ci`. O workspace em si não tem pipeline.