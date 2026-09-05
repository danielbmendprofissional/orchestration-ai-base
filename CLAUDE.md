# ai-base

Projeto base para todo novo workflow assistido por IA — sem stack fixa de frontend/backend. O que fica fixo aqui é o **processo**: discovery → spec → tickets → TDD → review → commit → merge request para branch protegida (validação humana).

## Papéis fixos das ferramentas

- **Claude Code**: pensar, arquitetar, montar specs/tasks, revisar, decidir. É quem roda as skills abaixo.
- **Deepseek V4 Flash / GPT-5.6 Luna (via OpenCode e/ou pi.dev)**: executar — implementar tickets já especificados, rodar TDD mecânico, tarefas repetitivas de baixo julgamento.

## Stack fixa de frontend

**Angular** é a stack fixa pra todo site/aplicativo web enterprise/SaaS criado a partir deste template — não é mais uma decisão em aberto por projeto. React fica reservado só pra landing page isolada ou uso futuro pontual, quando a spec deixar isso explícito. Ver `docs/design/component-library.md` (PrimeNG como biblioteca de componentes default, skills oficiais do Angular) e `docs/design/principios.md` (cadeia `ui-ux-pro-max-skill` + `impeccable.style` + `avoid-ai-design` contra ai-slop).

Ver `docs/workflow.md` para o fluxo completo ponta a ponta, `docs/agents/orchestration.md` para como o pi.dev orquestra os subagents executores (data/backend/front/ui/tests/security/review, sempre em deepseek-flash ou gpt-5.6-luna), `docs/design/` para tokens/biblioteca de componentes/princípios anti-ai-slop, e `pratices/tokens/` para a configuração de economia de tokens.

## Agent skills

Todas as skills em `.claude/skills/` têm `disable-model-invocation: true` — nenhuma dispara sozinha por descrição bater com o contexto. Só rodam quando chamadas explicitamente (`/grill-me`, "use a skill code-review", etc.). Isso é deliberado, pra não gastar token com skill que o agente decidiu invocar por conta própria.

### Issue tracker

Issues e specs vivem no GitLab, via GitLab MCP — a configurar por projeto, já que cada projeto criado a partir deste template aponta pro seu próprio repositório GitLab (este `ai-base` não é o repo de trabalho de ninguém, é só o template). Ver `docs/agents/issue-tracker.md` para o estado atual (hoje documenta o fallback manual via `glab`; a integração via MCP fica pendente de configuração quando um projeto real for criado).

### Triage labels

Vocabulário padrão de 5 papéis (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). Ver `docs/agents/triage-labels.md`.

### Domain docs

Layout single-context: `CONTEXT.md` + `docs/adr/` na raiz. Ver `docs/agents/domain.md`.

## Convenções de repo

Fluxo de branches (promoção via esteira de deploy, não é só uma branch protegida):

```
feature-x → MR → dev → qa → hml → master
```

- O agente sempre sobe o trabalho em `feature-x` e abre merge request pra `dev` — nunca commita direto em nenhuma das branches promovidas.
- `dev`, `qa`, `hml` e `master` são todas protegidas; a promoção entre elas é feita pela esteira de deploy (a configurar — ver item de infra do projeto), não por push manual.
- Futuro (ainda não habilitado): hotfix direto em `master`, mas sempre com aprovação prévia de código humana antes do merge — não é um bypass do processo, é uma rota de emergência com o mesmo gate de revisão.
- **Isso é reforçado por hook** (`.claude/hooks/block-dangerous-git.sh`, via skill `git-guardrails-claude-code`): bloqueia `git push` direto em `main`/`master`/`dev`/`qa`/`hml`, `--force`, `reset --hard`, `clean -f`, `branch -D`, `checkout .`/`restore .`. Push de feature branch funciona normal.
- Specs e tickets seguem `docs/workflow.md`.
