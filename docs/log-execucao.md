# Log de execução — comandos rodados de verdade

Registro de cada comando de `docs/comandos-para-rodar.md` que já foi efetivamente executado (por mim, via device bridge, ou por você), com data e resultado. Objetivo: saber sem ambiguidade o que já rodou de verdade versus o que ainda é só instrução escrita.

## 2026-09-07 — Reorganização: skills deixam de ser vendorizadas

A Seção 8 de `comandos-para-rodar.md` foi reescrita: antes só cobria as skills do Angular, marcadas como já instaladas; o restante (`.claude/skills/*` do Matt Pocock e do `avoid-ai-design`) já estava presente no repo, mas commitado direto, sem `.gitignore` nem comando de instalação documentado — vendorizado por engano, não por decisão.

Confirmado via `skills-lock.json`: das 28 pastas em `.claude/skills/`, 27 têm entrada no lock (25 de `mattpocock/skills`, 2 de `angular/skills`) — instaladas por `npx skills add`, não escritas à mão. A pasta restante, `avoid-ai-design`, tem `LICENSE`/`README.md` próprios (`github.com/funboy322/avoid-ai-design`, instalação via `git clone`, documentada no README dela).

Ação tomada: `.claude/skills/*` adicionado ao `.gitignore` e removido do controle de versão (`git rm -r --cached`) — os arquivos continuam no disco, só pararam de ser rastreados. `skills-lock.json` continua versionado (é a receita de reinstalação). Comandos de instalação de Matt Pocock e `avoid-ai-design`, que já tinham rodado antes sem registro aqui, ficam documentados na Seção 8 revisada — sem data/comando exato de quando rodaram originalmente, só a confirmação de que já estão instalados.

## 2026-09-05 — Seção 8 (antiga): skills oficiais do Angular

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
