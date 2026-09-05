---
description: Fluxo completo de uma task de spec - data -> backend -> front -> ui -> tests -> security -> review, em chain
---
Use a tool `task` com o parametro `chain` (agentScope: "both") para executar este fluxo, na ordem, cada etapa recebendo o resultado da anterior via `{previous}`:

1. Se a task tocar dados/schema: use o agent "data" para: $@
2. Se a task tocar logica de backend: use o agent "backend", usando o contexto de {previous} quando existir.
3. Se a task tocar integracao de frontend: use o agent "front", usando {previous}.
4. Se a task tocar UI/visual: use o agent "ui", usando {previous}.
5. Use o agent "tests" para rodar a suite inteira e cobrir as bordas entre as fatias acima, usando {previous}.
6. Use o agent "security" para revisar/corrigir a task inteira, usando {previous}.
7. Use o agent "review" (somente leitura) para dar o veredito final PASS/FAIL, usando {previous}.

Pule as etapas que nao se aplicam a esta task especifica (nem toda task tem fatia de UI, por exemplo) mas NUNCA pule tests, security e review.

Ao final, resuma o veredito do agent "review". Se for FAIL, pare aqui e nao comite nada — reabra a task com o subagent responsavel. Se for PASS, voce (o agente pai desta sessao `pi`) pode prosseguir para commit na branch de feature desta spec, conforme docs/workflow.md do repo.
