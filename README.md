# ai-base

Projeto base pra todo novo workflow assistido por IA — stack-agnóstico no backend, Angular fixo no frontend. O que este repo fixa é o **processo**: discovery → spec → tickets → TDD → review → commit → merge request → esteira de deploy.

## Por onde começar

- **Configurar sua máquina** (pi.dev, Alethe, glab, autenticação, skills): `docs-human/comandos-para-rodar.md`.
- **Ferramentas de design e onde gastar esforço/dinheiro**: `docs-human/ui-ux.md`.
- **O que já foi decidido mas ainda não implementado**: `docs-human/pendencias.md`.
- **O que já rodou de verdade** (comando por comando, com data e resultado): `docs-human/log-execucao.md`.

## Estrutura do repo

- `CLAUDE.md` — instruções de projeto pro Claude Code.
- `docs/workflow.md` — o pipeline completo, discovery → esteira de deploy.
- `docs/agents/` — configuração de skills (issue tracker, labels de triagem, docs de domínio), orquestração de execução (`orchestration.md`), esteira de deploy (`esteira-deploy.md`), infra compartilhada (`infra-local.md`), observabilidade e backup.
- `docs/design/` — stack de UI fixa (Angular + PrimeNG + Tailwind), cadeia anti-ai-slop (`principios.md`), tokens de design (`tokens.md`), catálogo de referência (`referencias.md`).
- `.claude/skills/` — **não versionado** (ver `.gitignore`): skills reinstaláveis por comando, não commitadas. `skills-lock.json` (esse sim versionado) registra origem e hash de cada uma, pra reinstalar de forma reprodutível.
- `.claude/hooks/` — guardrail de git (bloqueia push direto em branch protegida, force push, reset hard, etc — só vale pra sessão Claude Code).
- `.pi/` — camada de execução: subagents de papel (data, backend, front, ui, tests, security, review) rodando via pi.dev.
- `pratices/tokens/` — configuração de economia de token.