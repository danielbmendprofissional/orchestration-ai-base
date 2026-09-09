# Runbook: nascimento de projeto novo

Sequência única, do zero até publicado. Cada passo aponta pro arquivo que tem o comando/detalhe completo — isso aqui só amarra a ordem.

## 1. Criar o repo a partir do `ai-base`

Copiar a estrutura do template pro repo novo do projeto (`docs/`, `docs-human/`, `.pi/agents/`, `.claude/`, `.gitlab-ci.yml`).

## 2. Apontar pra infra compartilhada de dev

Rodar os comandos do passo 11 de `comandos-para-rodar.md`:
- Postgres: criar banco `<projeto>` + `infra/banco/<projeto>/init-db.sql` (organização interna — schema por módulo ou não — é decisão do projeto).
- RabbitMQ: criar vhost `<projeto>`.
- Keycloak: criar realm `<projeto>`.
- Redis: criar ACL user `<projeto>` restrito a `<projeto>:*`.

Guardar as senhas geradas do jeito que você já guarda as outras (nunca versionado).

## 3. Configurar a API .NET pros pontos fixos de infra

Isso é regra do `ai-base` (`docs/agents/infra-local.md`, `docs/agents/observabilidade-backup.md`), independente da arquitetura interna que o projeto escolher:
- `/health` via `Microsoft.Extensions.Diagnostics.HealthChecks`, checando Postgres/Redis/RabbitMQ/Keycloak.
- `/metrics` via `prometheus-net.AspNetCore`.
- Log em JSON no console (Serilog ou equivalente) — é o que o Grafana Alloy espera pra indexar.

## 4. Registrar o projeto no Prometheus

Adicionar 1 linha nova em `infra/container/prometheus.yml`, apontando pro `/metrics` da API do projeto.

## 5. Ligar a esteira de CI/CD

No `.gitlab-ci.yml` do projeto (herdado do template): confirmar que o include do `/review/code-review-verify.yml` está lá, os jobs `verify-code-review`/`abrir-mr-dev`, e a regra `feature/*` no `workflow.rules` — ver `docs/agents/orchestration.md` e `docs/agents/esteira-deploy.md` pro fluxo completo (tag `vX.Y.Z-rcN`, promoção dev→qa→hml→master).

Autenticar `glab` no runner se ainda não tiver feito (passo 5 de `comandos-para-rodar.md`).

## 6. Primeiro ciclo de desenvolvimento (local, sem nuvem ainda)

Nada abaixo precisa de Kubernetes nem AWS — roda tudo local:
- Specs viram issues no GitLab (`docs/agents/issue-tracker.md`).
- `pi` executa via `/implement-task`, um painel do Alethe por spec (`docs/agents/orchestration.md`).
- `/code-review` manual (sua sessão Claude Code, seu Pro) antes de cada push de `feature/*`.
- Esteira dev→qa→hml→master só entra em jogo quando você decidir publicar de verdade.

## 7. Publicar pela primeira vez — só quando decidir ir pra nuvem

Aqui entra o Kubernetes. Kit de bootstrap completo (comandos exatos) já registrado em `docs-human/pendencias.md`, seção Kubernetes:
- A) Criar EC2 + instalar k3s.
- B) cert-manager + `ClusterIssuer` Let's Encrypt.
- C) Registrar o GitLab Kubernetes Agent.
- D) Instalar os 4 operators (CloudNativePG, Redis Operator, RabbitMQ Cluster Operator, Keycloak Operator).

Repete A→B→C→D pra cada cluster — 1 por projeto × ambiente (`qa`, `hml`, `master`), conforme Opção 3 decidida.

## 8. Segurança (quando o `DefectDojo` já estiver rodando no `infra`)

Rodar o `Security-Scanner` contra o projeto, importar achados no DefectDojo via API (ver `docs-human/pendencias.md`, checklist do DefectDojo).