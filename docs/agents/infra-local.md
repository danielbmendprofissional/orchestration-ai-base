# Infra local: serviços de contexto + segurança

Registro da decisão sobre o item 3 do `README.md` (Docker/Kubernetes + serviços de contexto: Redis, Postgres, RabbitMQ, Keycloak — e a integração do `Security-Scanner`/DefectDojo). Decidido em conversa com Daniel em 2026-09-05. Este documento só registra a decisão — **não foi implementado ainda**.

## O que já existe (descoberto durante a discussão, não criado agora)

Existem dois repos separados já com trabalho real feito, e nenhum dos dois estava linkado no `README.md` deste projeto antes desta conversa:

- **`infra`** (`C:\Users\danib\source\repos\infra`, `gitlab.com/personal.daniel.bmend/infra`) — já tem um `docker-compose.yml` (`container/docker-compose.yml`) rodando **Postgres, pgAdmin, Redis, RabbitMQ e Keycloak** — ou seja, 4 dos serviços de contexto que o item 3 do README já prometia, prontos e funcionando localmente (não é proposta, é o que já roda na máquina do Daniel). Junto tem `configs/` (perfis de VS Code, MCPs do Claude Desktop/OpenCode, PowerShell) e `banco/valuto/init-db.sql` — um script de inicialização de banco **específico do projeto Valuto** (schemas `identity`, `financial`, `personal`, `calendar`, `notifications`, `wolverine`/outbox), misturado no mesmo repo com a parte genérica.
- **`Security-Scanner`** (`C:\Users\danib\source\repos\Security-Scanner`) — CLI .NET já validado (778 findings consolidados num scan de teste), orquestra Trivy/Opengrep/Checkov/BetterLeaks/ZAP via Docker, exporta JSON/PDF local e importa no **DefectDojo self-hosted** via API. Hoje o DefectDojo roda **separado**, como um clone à parte do `django-DefectDojo` oficial com seu próprio `docker compose`, documentado no `README.md` do `Security-Scanner`.

## Decisão 1 — Infra local compartilhada, não por projeto

O `docker-compose.yml` do `infra` continua sendo **uma instância só, permanente, rodando na máquina do Daniel** — não um compose por projeto. Todo projeto nascido do `ai-base` aponta sua connection string (Postgres/Redis/RabbitMQ/Keycloak) pra essa instância compartilhada em vez de subir containers próprios.

Trade-off aceito conscientemente: projetos concorrentes competem pela mesma instância/portas (ex: dois projetos não podem usar o Postgres compartilhado com o mesmo nome de banco sem conflito — o padrão de `banco/valuto/init-db.sql`, com `\c valuto` e schemas próprios por domínio, é o caminho: **um banco por projeto dentro da mesma instância Postgres**, não uma instância Postgres por projeto).

**Consequência prática:** a parte genérica do `infra` (o `docker-compose.yml`, os `configs/`) é o que o `ai-base` referencia; a parte específica do Valuto (`banco/valuto/`) fica fora do escopo de reuso — mesmo padrão de separação genérico/específico já aplicado ao `template-ci` (`personal/` vs. `tce/`) em `docs/agents/esteira-deploy.md`. Cada projeto novo ganha seu próprio `banco/<projeto>/init-db.sql` dentro do `infra`, ao lado do `valuto/` existente, não em cima dele.

## Decisão 2 — Kubernetes continua no plano, mesmo sem nada implementado ainda

Hoje o `infra` é só Docker Compose de dev local (o próprio `docker-compose.yml` comenta `shm_size: 128mb # valor de dev local`) — não existe nenhum manifesto Kubernetes em nenhum dos repos envolvidos. A decisão foi **não reescopar o item 3 pra "só Compose"**: Kubernetes segue como meta, a planejar do zero quando esse trabalho for retomado. Isso significa que o item 3 tem duas frentes com maturidade bem diferente: infra de dev local (adiantada, só falta formalizar) e orquestração de produção via K8s (não iniciada).

## Decisão 3 — DefectDojo unifica no `infra`

Hoje o `Security-Scanner/README.md` documenta o DefectDojo como um clone separado do `django-DefectDojo`, com seu próprio `docker compose`, rodado à parte. A decisão foi **trazer o DefectDojo pra dentro do `docker-compose.yml` do `infra`**, como mais um serviço permanente da máquina, junto de Postgres/Redis/RabbitMQ/Keycloak — em vez de continuar como um segundo compose isolado.

Isso muda dois arquivos que ainda não foram tocados:
- `infra/container/docker-compose.yml` — precisa ganhar o(s) serviço(s) do DefectDojo (ele mesmo é multi-serviço: Django/uWSGI, Celery, Postgres próprio ou compartilhado, Redis próprio ou compartilhado — decidir se o DefectDojo reaproveita o Postgres/Redis já existentes no `infra` ou mantém os seus, na hora de implementar).
- `Security-Scanner/README.md` — a seção "DefectDojo não faz parte deste repositório" precisa ser atualizada pra apontar pro `infra` como o lugar onde ele roda, mantendo as instruções de credencial (`DEFECTDOJO_URL`/`DEFECTDOJO_API_KEY` via User Secrets/variável de ambiente) como estão.

## O que ainda não foi decidido

- Se o DefectDojo compartilha o Postgres/Redis do `infra` ou mantém instâncias próprias dentro do mesmo compose (fica pra hora de implementar).
- O desenho de Kubernetes em si (nada planejado ainda — Decisão 2 só mantém a intenção, não define arquitetura).
- Se/como o `infra` também vira algo "consumível" por projetos do `ai-base` de forma mais formal (ex: um doc tipo `docs/comandos-para-rodar.md` explicando como apontar um projeto novo pra essa infra compartilhada) — hoje é só a decisão de modelo, não a documentação operacional.

## Referências

- `infra/container/docker-compose.yml`, `infra/banco/valuto/init-db.sql` — estado atual (commit `e13c513` na data desta decisão).
- `Security-Scanner/README.md` — estado atual do CLI e do fluxo com DefectDojo (commit `740a1f1` na data desta decisão).
- `docs/agents/esteira-deploy.md` deste repo — mesmo padrão de separação genérico/específico, aplicado ao `template-ci`.
