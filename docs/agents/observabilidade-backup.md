# Observabilidade e backup da infra compartilhada

Registro da decisão sobre as duas lacunas identificadas em `docs/agents/infra-local.md`: o `docker-compose.yml` do `infra` não tinha nenhuma peça de logging/monitoramento, e o Postgres compartilhado (que já guarda dado real do Valuto, incluindo o schema `financial`) não tinha estratégia de backup nenhuma. Decidido em conversa com Daniel em 2026-09-05. **Não foi implementado ainda.**

## Decisão 1 — Observabilidade completa: Grafana + Loki + Prometheus, dentro do `infra`

Em vez do mínimo (só Serilog + health check), a decisão foi subir um stack de observabilidade self-hosted de verdade, como mais serviços permanentes no `docker-compose.yml` do `infra`, ao lado de Postgres/Redis/RabbitMQ/Keycloak/DefectDojo:

- **Prometheus** — coleta de métricas. Precisa de um exporter por serviço: `postgres_exporter`, `redis_exporter`, o plugin de métricas nativo do RabbitMQ (`rabbitmq_prometheus`, já embutido na imagem `management`), e um exporter de métrica da própria aplicação .NET (`prometheus-net.AspNetCore`, expõe `/metrics`).
- **Loki + Grafana** — agregação de log centralizada. Duas formas de levar log da aplicação .NET até o Loki, a decidir na hora de implementar: (a) Serilog com sink direto (`Serilog.Sinks.Grafana.Loki`), sem intermediário; ou (b) Serilog escrevendo JSON estruturado no console/arquivo (capturado pelo Docker) + **Promtail** coletando de todos os containers, inclusive os que não são .NET (Keycloak, DefectDojo). A opção (b) cobre mais coisa com menos código por serviço; a (a) é mais direta só pra apps .NET.
- **Grafana** — UI de dashboard + alerta, consumindo Prometheus e Loki como datasources.
- **Health check endpoint** (`/health`, via `Microsoft.Extensions.Diagnostics.HealthChecks` no .NET, checando Postgres/Redis/RabbitMQ/Keycloak) continua necessário independente do stack acima — é o que falta pro smoke-test do `template-ci` cobrir .NET (hoje só cobre Angular via `APP_ENVIRONMENT_URL`, ver `docs/agents/esteira-deploy.md`). Esse endpoint também vira o alvo natural de um scrape do Prometheus.

**Dependência não resolvida:** a stack completa de logging pressupõe uma stack de backend .NET já formalizada (padrão de logging estruturado, onde o health check endpoint vive na arquitetura da API). Isso ainda não foi discutido como decisão própria — fica como pendência separada (ver "O que ainda falta" abaixo).

**Custo de operação, avaliar na implementação:** Grafana+Loki+Prometheus é bem mais pesado que o mínimo — mais 3+ containers rodando permanentemente na mesma máquina que já roda Postgres/Redis/RabbitMQ/Keycloak/DefectDojo, mais retenção de log/métrica ocupando disco (definir período de retenção do Loki, ex: 14–30 dias, pra não crescer sem limite).

## Decisão 2 — Backup do Postgres: local + cópia externa

`pg_dump` agendado, com rotação (proposta de partida: 7 dumps diários + 4 semanais, a confirmar na implementação), salvo localmente e sincronizado pra um armazenamento externo — Google Drive, já que a assinatura Google já é paga (mesma lógica de `docs/design/ferramentas-por-custo.md`: usar o que já é pago antes de contratar algo novo).

Pontos que a implementação precisa resolver, não decididos ainda:
- **Dump por banco, não `pg_dumpall`.** A instância Postgres é compartilhada entre projetos (um banco por projeto, ver `docs/agents/infra-local.md`); um `pg_dump` por banco permite restaurar um projeto sem mexer nos outros. Só as **roles** são de cluster inteiro (os `vp_owner_<schema>`/`vp_usu_<schema>` criados em `banco/valuto/init-db.sql` e equivalentes de projetos futuros) — essas precisam de um `pg_dumpall --globals-only` à parte, incluído na rotina de backup.
- **Onde agendar.** A máquina é Windows — o agendamento é via Task Scheduler (não cron), rodando um script que chama `pg_dump`/`pg_dumpall` dentro do container ou via `docker exec`.
- **Como sincronizar pro Google Drive.** Duas opções, a escolher na implementação: colocar a pasta de saída do backup dentro da pasta já sincronizada pelo Google Drive for Desktop (se já instalado na máquina) — mais simples, zero ferramenta nova; ou `rclone` com um remote do Google Drive — mais controle (compressão, criptografia antes do upload), mas ferramenta extra.
- **Testar restore pelo menos uma vez** depois de implementado — um backup nunca testado não é garantia de nada.

## O que ainda falta (fora do escopo desta conversa)

- **Stack de backend formal (.NET)** — framework, ORM, arquitetura, onde o health check endpoint e o logging estruturado se encaixam na prática. Sinalizado como pendência quando as lacunas do `ai-base` foram levantadas; ainda não discutido a fundo.
- **Runbook de nascimento de projeto** — o checklist único amarrando esteira (`docs/agents/esteira-deploy.md`) + infra (`docs/agents/infra-local.md`) + este documento + a stack de backend, pra quando um projeto real nascer do `ai-base`. Também sinalizado e ainda não discutido.
- **Autenticação/autorização via Keycloak** — como Angular e .NET se integram com o Keycloak que já roda no `infra`. Também sinalizado e ainda não discutido.

## Referências

- `docs/agents/infra-local.md` — decisão de infra compartilhada onde este stack de observabilidade/backup se encaixa.
- `docs/agents/esteira-deploy.md` — smoke-test do `template-ci`, hoje só Angular; o health check endpoint decidido aqui é o que falta pra estender pro .NET.
- `docs/design/ferramentas-por-custo.md` — mesma lógica de "usar o que já é pago antes de contratar algo novo", aplicada aqui à escolha do Google Drive pro backup externo.
