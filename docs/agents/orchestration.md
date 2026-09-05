# Orquestracao de execucao: pi.dev + Alethe

Camada de EXECUCAO deste projeto (item 4). Fica por dentro do passo `/implement` de `docs/workflow.md`: Claude Code fecha a spec e as tasks (data, backend, front, ui, tests, review, security); a partir dai, quem executa é uma sessao `pi` (pi.dev) rodando neste repo, com subagents fazendo cada task. Claude Code entra de novo depois, de fora, pra revisar/validar antes do merge request.

Nao existe um "agente pai" fixo além do proprio processo `pi` — cada CLI `pi` que voce abre (uma por spec) É o agente pai daquela spec, orquestrando os subagents abaixo dela via a tool `task`.

## O que ja esta pronto neste repo

- `.pi/extensions/subagent/` — extensao oficial do pi.dev (vendorizada, ver o README dela pra saber o que foi alterado) que da ao `pi` a tool `task` (single / parallel / chain de subagents).
- `.pi/agents/*.md` — os 7 subagents de papel: `data`, `backend`, `front`, `ui`, `tests`, `security`, `review`. `data`/`backend`/`tests`/`security` rodam em `deepseek/deepseek-v4-flash`; `front`/`ui`/`review` em `openai/gpt-5.6-luna`. Mude o campo `model:` de qualquer um se quiser trocar.
- `.pi/extensions/subagent/prompts/implement-task.md` — comando `/implement-task <descricao>` que encadeia os 7 papeis numa chain (pula os que nao se aplicam, nunca pula tests/security/review).

## Instalar o pi.dev na sua maquina (Windows)

Isso precisa rodar no SEU terminal real (PowerShell ou Git Bash), nao dentro do sandbox do Cowork — o que eu instalei aqui foi só pra validar a config, nao fica disponivel pra voce usar depois desta sessao.

```powershell
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
```

Pi usa Git Bash no Windows por padrao (checa `C:\Program Files\Git\bin\bash.exe`) — se voce ja usa `git` normalmente, o Git for Windows ja deve estar instalado.

## Autenticar Deepseek e GPT-5.6 Luna

Os dois são providers **built-in** do pi.dev — não precisa de `models.json`, só autenticar:

```powershell
$env:DEEPSEEK_API_KEY="sua-chave-deepseek"
$env:OPENAI_API_KEY="sua-chave-openai"
```

Ou, dentro de uma sessao `pi` interativa: `/login deepseek` e `/login openai` (grava em `~/.pi/agent/auth.json`, sobrevive entre sessoes — nao precisa repetir a variavel de ambiente toda vez).

## Rodar uma spec

Dentro da pasta do repo (numa branch de feature ou de spec já criada por voce/Claude Code):

```
pi
```

O `pi` carrega `CLAUDE.md` automaticamente (ele le `AGENTS.md`/`CLAUDE.md` por padrao) e os 7 subagents de `.pi/agents/`. Dentro da sessao:

```
/implement-task Tela de cadastro de usuario: validar CPF, salvar em users, exibir erro de duplicidade
```

Ou, pra rodar so uma fatia (task pontual sem precisar do prompt inteiro):

```
Use o agent "backend" para: endpoint POST /users com validacao de CPF
```

Ou em paralelo (fatias que nao dependem uma da outra):

```
Rode data e front em paralelo: data cria a tabela users; front monta o formulario de cadastro consumindo /users
```

## O agente pai valida e sobe a branch

Depois que o subagent `review` (ultimo da chain) devolver `PASS`, é o proprio `pi` (voce, na sessao) quem roda o commit/push — ele nao faz isso sozinho de forma automatica, é um passo que voce (ou uma instrucao sua dentro da sessao) dispara:

```
git add -A && git commit -m "..." && git push origin feature/<spec>
```

O hook `.claude/hooks/block-dangerous-git.sh` só vale pra sessoes de Claude Code, nao pro `pi` — ainda assim, a convencao do repo (branch de feature, nunca push direto em `main`) vale igual. Quando **todas** as specs de uma feature estiverem prontas, quem abre a merge request pra branch protegida e faz a revisao final é o fluxo de fora, com Claude Code (`/code-review`, depois `glab mr create`) — nao o `pi`.

## Rodando 4 specs ao mesmo tempo, em tela cheia: Alethe

[Alethe](https://github.com/Kc1t/alethe-agents) (`Kc1t/alethe-agents`) é um workspace desktop free e open source (AGPL-3.0-or-later), com instalador nativo pra Windows, macOS e Linux. Ele não conhece o `pi.dev` como agente "nomeado" (a lista dele cita Claude Code, Codex, OpenCode) — mas gerencia PTYs/terminais genéricos com layouts de grid, split-pane e sub-tabs, então roda `pi` como qualquer outro comando de terminal, sem diferença prática.

Uso: abra o Alethe, monte um layout de grid 4 paineis, e em cada painel:

```
cd caminho\para\ai-base
git checkout -b feature/<feature>/<spec-N>   # uma branch por spec
pi
```

Cada painel vira uma sessao `pi` independente orquestrando uma spec. O Alethe guarda layout e historico de sessao, entao da pra fechar e retomar depois.

## Sobre o Gas Town (nota, nao usado por enquanto)

O Gas Town (`gastownhall/gastown`) automatiza uma camada acima disso — uma fila de merge (Refinery) que valida e junta o trabalho de varias specs (Convoys/Beads) automaticamente, sem voce acompanhar terminal por terminal. Fica registrado como opcao futura se este fluxo manual (4 paineis do Alethe) virar gargalo — não foi adotado agora porque o pedido era orquestrar via pi.dev diretamente.
