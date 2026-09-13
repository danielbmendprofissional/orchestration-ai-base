# Orquestração de execução: pi.dev + Alethe

Camada de execução, dentro do passo `/implement` de `docs/workflow.md`: Claude Code fecha spec e tasks (data, backend, front, ui, tests, review, security); uma sessão `pi` (pi.dev) executa, com subagents fazendo cada task; Claude Code entra de novo depois pra revisar/validar antes da MR.

Não existe agente-pai fixo além do próprio processo `pi` — cada CLI `pi` aberta (uma por spec) é o agente-pai daquela spec, orquestrando os subagents via a tool `task`.

Economia de tokens: RTK ligado, quando disponível na máquina (instalação/configuração é setup de máquina, fora deste repo). Caveman nunca — exclusivo de sessões Claude Code.

## Subagents (`.pi/agents/*.md`)

7 papéis: `data`, `backend`, `front`, `ui`, `tests`, `security`, `review`. Sem papel fixo de modelo — qualquer um pode rodar em `deepseek/deepseek-v4-flash` ou `openai/gpt-5.6-luna`, campo `model:` de cada arquivo controla isso.

Comando `/implement-task <descrição>` encadeia os 7 papéis, pulando os que não se aplicam — nunca pula `tests`/`security`/`review`.

## Depois do `review` dar PASS

O agente-pai (`pi`) faz commit/push da branch de feature — nunca push direto em `dev`/`qa`/`hml`/`master`, mesma convenção do resto do repo (o hook `.claude/hooks/block-dangerous-git.sh` só roda em sessão Claude Code, não no `pi`, mas a regra vale igual pra ele).

`/code-review` roda manual, local, numa sessão interativa normal do Claude Code (nunca headless/`-p` disparado pelo CI — risco de cobrança fora do plano de assinatura). Ao terminar com PASS, grava `.pi/code-review-ok.json` (hash do commit revisado + data/hora) — esse arquivo entra no commit normal da branch.

O push em `feature/*` dispara um stage `verify-code-review` no GitLab CI: só bash, sem chamar IA nenhuma — confere se `.pi/code-review-ok.json` existe e se o hash gravado bate com o commit do push. Bateu: o mesmo job abre a MR pra `dev` automaticamente (`glab mr create --target-branch dev`). Não bateu ou não existe: pipeline falha, nenhuma MR é aberta — quem estiver rodando o `pi` precisa rodar `/code-review` de novo antes de reenviar. Promoção `dev → qa/hml/master` é a esteira de deploy (ver `docs/agents/esteira-deploy.md`), nenhum agente faz isso diretamente.

## Execução paralela

Múltiplas specs rodam em sessões `pi` paralelas, uma branch de feature por spec (via Alethe — instalação/uso é setup de máquina, fora deste repo).