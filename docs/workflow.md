# Fluxo TDD + SDD

Pipeline padrão deste projeto base, construído em cima das skills de Matt Pocock instaladas em `.claude/skills/`. Cada seta abaixo é um comando de skill; a ordem é a intencionada pelo autor das skills — não pule etapas sem necessidade.

```
/grill-me | /grill-with-docs        (discovery)
        ↓
/wayfinder                          (só se o trabalho for grande demais p/ 1 sessão — cria map + tickets filhos)
        ↓
/to-spec                            (spec-driven: conversa → spec formal, publicada no tracker)
        ↓
/to-tickets                         (spec → fatias/tickets, cada um com dependências bloqueantes declaradas)
        ↓
/implement                          (test-driven: executa cada ticket com TDD — invoca a skill /tdd internamente: red → green → refactor)
        ↓
/code-review                        (avalia o diff em dois eixos: padrão do repo + conformidade com a spec)
        ↓
commit (mensagens claras, um commit por unidade lógica)
        ↓
merge request → branch protegida (main) → validação humana (Daniel aprova)
```

## Onde cada skill entra

**Discovery (SDD, começo).** `/grill-me` é a entrada mais simples (entrevista genérica até fechar decisão/plano). `/grill-with-docs` é a variante para trabalho de engenharia: entrevista + modelo de domínio, grava termos em `CONTEXT.md` via `/domain-modeling`.

**Trabalho grande demais para uma sessão.** `/wayfinder` monta um mapa compartilhado (issue `wayfinder:map` no GitLab) com tickets filhos, dependências e uma "fronteira" de trabalho desbloqueado — usar antes de `/to-spec` quando o escopo é claramente multi-sessão.

**Prototipagem descartável.** `/prototype` quando é preciso validar uma ideia de UI/lógica em código jogável fora antes de comprometer com uma spec — roda fora do pipeline principal, alimenta o discovery.

**Spec e tickets (SDD, núcleo).** `/to-spec` converte a conversa de discovery numa spec formal publicada como issue no GitLab. `/to-tickets` quebra a spec em tickets rastreáveis (fatias), cada um declarando o que bloqueia e o que é bloqueado.

**Implementação (TDD, núcleo).** `/implement` executa um ticket nos pontos de integração combinados, test-first — a skill `tdd` (red-green-refactor) roda dentro dela. Não escrever código de produção sem um teste vermelho antes.

**Review.** `/code-review` avalia o diff contra dois eixos independentes: os padrões do repo (estilo, arquitetura, `docs/adr/`) e a conformidade com a spec original (`to-spec`). Rodar antes de abrir a merge request, não depois.

**Commit → Merge Request → branch protegida.** Commit granular, MR contra `main` (branch protegida — configuração em `.gitlab-ci.yml` e nas proteções do projeto no GitLab), merge só após validação humana. Ver `docs/agents/issue-tracker.md` para os comandos `glab mr ...`.

## Skills de apoio (usar quando a situação pedir, fora da sequência linear)

- `/diagnosing-bugs` — loop disciplinado de debug quando algo quebra fora do fluxo de implementação normal.
- `/resolving-merge-conflicts` — conflitos de merge na MR.
- `/improve-codebase-architecture` — varredura periódica de arquitetura (rodar a cada N dias/sprints, não por ticket).
- `/triage` — gerenciar o estado das issues no tracker (aplica os labels de `docs/agents/triage-labels.md`).
- `/retro` — retrospectiva de uma sessão de codificação, depois de fechar um ticket ou um bloco de trabalho.
- `/handoff` — compactar a conversa atual para outro agente/sessão continuar.
- `/ask-matt` — roteador entre as skills quando não tiver certeza de qual usar.

## Onde isso conecta com os agentes de execução

`/implement` é o ponto de handoff natural para os executores (Deepseek Flash / GPT-5.6 Luna via OpenCode ou pi.dev): a spec e o ticket já estão fechados antes de chegar aqui, então a etapa mecânica de TDD é onde o modelo mais barato entra. Claude Code permanece responsável por discovery, spec, tickets e review — a parte que exige julgamento.

Detalhamento da arquitetura de agentes (pi.dev + subagents deepseek-flash/gpt-5.6-luna, um `pi` por spec, layout de 4 paineis no Alethe) fica em `docs/agents/orchestration.md`.
