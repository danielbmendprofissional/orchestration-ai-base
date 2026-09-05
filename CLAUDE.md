# ai-base

Projeto base para todo novo workflow assistido por IA — sem stack fixa de frontend/backend. O que fica fixo aqui é o **processo**: discovery → spec → tickets → TDD → review → commit → merge request para branch protegida (validação humana).

## Papéis fixos das ferramentas

- **Claude Code**: pensar, arquitetar, montar specs/tasks, revisar, decidir. É quem roda as skills abaixo.
- **Deepseek V4 Flash / GPT-5.6 Luna (via OpenCode e/ou pi.dev)**: executar — implementar tickets já especificados, rodar TDD mecânico, tarefas repetitivas de baixo julgamento.

Ver `docs/workflow.md` para o fluxo completo ponta a ponta, `docs/agents/orchestration.md` para como o pi.dev orquestra os subagents executores (data/backend/front/ui/tests/security/review, sempre em deepseek-flash ou gpt-5.6-luna) e `pratices/tokens/` para a configuração de economia de tokens.

## Agent skills

### Issue tracker

Issues e specs vivem no GitLab (`gitlab.com/personal.daniel.bmend/ai-base`), via `glab`. Ver `docs/agents/issue-tracker.md`.

### Triage labels

Vocabulário padrão de 5 papéis (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). Ver `docs/agents/triage-labels.md`.

### Domain docs

Layout single-context: `CONTEXT.md` + `docs/adr/` na raiz. Ver `docs/agents/domain.md`.

## Convenções de repo

- Branch protegida: `main` (configuração de proteção e pipeline em `.gitlab-ci.yml` — ver item de infra do projeto).
- Nunca commitar direto em `main`: sempre feature branch → merge request → validação humana. **Isso é reforçado por hook** (`.claude/hooks/block-dangerous-git.sh`, via `git-guardrails-claude-code`): bloqueia `git push` direto pra `main`/`master`, `--force`, `reset --hard`, `clean -f`, `branch -D`, `checkout .`/`restore .`. Push de feature branch funciona normal.
- Specs e tickets seguem `docs/workflow.md`.
