# Log de execução — comandos rodados de verdade

Registro de cada comando de `docs/comandos-para-rodar.md` que já foi efetivamente executado (por mim, via device bridge, ou por você), com data e resultado. Objetivo: saber sem ambiguidade o que já rodou de verdade versus o que ainda é só instrução escrita.

## 2026-09-05 — Seção 8: skills oficiais do Angular

**Onde rodou:** direto na pasta real do `ai-base` (`C:\Users\danib\source\repos\ai-base`), via device bridge do Cowork — não no sandbox efêmero do Cowork (esse não persiste, ver aviso em `docs/agents/orchestration.md`).

**Comando:**

```
npx skills add https://github.com/angular/skills -s '*' -a claude-code -y
```

Nota: o comando original de `comandos-para-rodar.md` (`npx skills add https://github.com/angular/skills`) é interativo (pede pra escolher skills e agente na hora). Pra rodar sem prompt via automação, usei `-s '*' -a claude-code -y` — mesmo resultado que escolher "Select All" + "Claude Code" manualmente no prompt interativo.

**Resultado:** instalou as duas skills, copiadas (não symlink) pra `.claude/skills/`:

- `.claude/skills/angular-developer/` (`SKILL.md` + 37 arquivos em `references/`)
- `.claude/skills/angular-new-app/` (`SKILL.md`)

`skills-lock.json` atualizado com as entradas `angular-developer` e `angular-new-app` (source `angular/skills`, hash de cada `SKILL.md` registrado).

**Estado:** arquivos criados, ainda **não commitados** (aparecem como `??` em `git status`) — decisão de quando/como commitar fica com você.

## O que ainda não rodou

Seção 9 de `comandos-para-rodar.md` (PrimeNG, Tailwind, `ui-ux-pro-max-cli`, `impeccable.style`) continua bloqueada: o próprio arquivo explicita que só faz sentido dentro de um projeto Angular real, e o `ai-base` é só o template — não existe app ainda pra instalar essas ferramentas dentro. Fica pendente até nascer o primeiro projeto real.

Seções 1–7 (pré-requisitos, `pi.dev`, autenticação Deepseek/OpenAI, Alethe, `glab`, teste de sessão `pi`) não foram verificadas nem executadas nesta sessão — ver `docs/comandos-para-rodar.md` pra rodar quando fizer sentido.
