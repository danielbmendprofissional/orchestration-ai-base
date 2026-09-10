# Pendências (docs-human — a IA não precisa ler isto)

Acumulado enquanto os `.md` de `docs/` são limpos. Cada item é algo que só importa pra você decidir/acompanhar, não pra IA seguir regra.

## Ordem de implementação combinada (tudo abaixo já está decidido, só falta executar)

1. DefectDojo entrar no compose do `infra`.
2. Observabilidade (Prometheus+exporters, Grafana, Loki, Alloy) + backup (`pg_dump` rotação + sync `G:\My Drive\ia`).
3. Esteira: `/code-review` gravar `.pi/code-review-ok.json` + stage `verify-code-review` no `.gitlab-ci.yml`.
4. Kubernetes: primeiro cluster k3s, Traefik+cert-manager, GitLab Kubernetes Agent, os 4 operators.
5. Nascimento de projeto: comandos do passo 11 (`comandos-para-rodar.md`), rodar quando nascer o próximo projeto.

Motivo da ordem: 1-2-3 mexem só no que já existe (`infra`, GitLab), sem depender de nuvem nova; Kubernetes fica por último por ser o que exige AWS/aprendizado novo.

## De esteira-deploy.md

- **Gatilho `pi` → `/code-review` → MR: redesenhado por risco de cobrança, falta implementar.** Motivo da mudança: `claude -p` (headless) tem bug documentado (issue #43333 no GitHub do Claude Code) de cobrar como API avulsa mesmo sem chave configurada e mesmo em conta Pro/Max — sem trava de gasto máximo garantida fora de conta Enterprise. Decisão final: `/code-review` roda manual, local, sessão normal do Claude Code (conta com seu Pro, sem risco) — ao passar, grava `.pi/code-review-ok.json` (hash do commit + data). Stage `verify-code-review` no GitLab CI só confere esse arquivo por bash (zero chamada de IA, zero custo) — bateu o hash, abre a MR sozinho (`glab mr create`); não bateu/não existe, pipeline falha e pede rodar `/code-review` de novo. Falta: escrever o stage `verify-code-review` de verdade no `.gitlab-ci.yml`/`template-ci`, e ajustar o `/code-review` (comando do Claude Code) pra gravar o `.pi/code-review-ok.json` ao final.
- **Agente de QA usa Playwright, via Docker** (decidido, config e comando em `docs-human/comandos-para-rodar.md` item 10). Precisa de Docker Desktop rodando na máquina que executa o agente `qa`.

## De infra-local.md

- Repo `infra` fica em `gitlab.com/personal.daniel.bmend/infra`, já tem `docker-compose.yml` com Postgres/pgAdmin/Redis/RabbitMQ/Keycloak rodando de verdade, mais `configs/` (perfis VS Code, MCPs, PowerShell).
- **Novo, ainda não implementado: pgAudit no serviço `postgres`.** A imagem `postgres:17-alpine` usada hoje não vem com a extensão pronta — precisa de `Dockerfile` customizado (a partir de `postgres:17-alpine`, compilando/instalando `pgaudit`) ou trocar de imagem. Uma vez ligado (`shared_preload_libraries = 'pgaudit'` + envs de `pgaudit.log`), o log cai automático no Grafana via o `alloy` que já capta log de todo container — não precisa de pipeline novo, só a configuração da extensão em si. Avaliar se vale fazer agora ou esperar a migração pra CloudNativePG (Kubernetes), onde costuma vir mais pronto — ver `docs/agents/kubernetes-security.md`.
- **Novo, ainda não implementado: Falco (runtime security).** Monitora o host/containers rodando de verdade via `docker.sock` (mesmo socket que o `alloy` já monta), diferente do Trivy/Checkov que só escaneiam antes de rodar. Esboço de serviço pro `docker-compose.yml` já rascunhado em `docs/agents/infra-local.md`, seção "Segurança de banco e runtime" — falta só aplicar (imagem oficial `falcosecurity/falco`, confirmar tag mais recente na hora, roda com `privileged: true`).
- **Kubernetes: kit de bootstrap A→B→C→D (ver seção mais abaixo), mais um passo E não decidido no detalhe ainda: segurança de cluster (`kube-bench`, Falco em DaemonSet) — ver `docs/agents/kubernetes-security.md`, que documenta a intenção mas não é executável até o passo D estar de pé.**
- `Security-Scanner` (CLI .NET, repo separado) já validado — 778 findings num scan de teste, orquestra Trivy/Opengrep/Checkov/BetterLeaks/ZAP, exporta JSON/PDF e importa no DefectDojo via API. Hoje DefectDojo roda **separado** (clone próprio do `django-DefectDojo` — obs: o `docker-compose.yml` original desse clone foi perdido, não existe mais). Checklist pra trazer ele pro `infra` (config completa já passada no chat):
  1. Criar o banco `defectdojo` no Postgres compartilhado.
  2. Adicionar os 5 serviços (`defectdojo-nginx`, `-uwsgi`, `-celerybeat`, `-celeryworker`, `-initializer`) no `infra/container/docker-compose.yml`, apontando `DD_DATABASE_URL` pro Postgres compartilhado e `DD_CELERY_BROKER_URL` pro Redis compartilhado (`/1`, banco lógico separado do índice 0).
  3. Adicionar no `.env` do `infra`: `DD_SECRET_KEY`, `DD_CREDENTIAL_AES_256_KEY` (gerar aleatório, 32+ chars cada), `DD_ADMIN_USER`, `DD_ADMIN_MAIL`, `DD_ADMIN_FIRST_NAME`, `DD_ADMIN_LAST_NAME`, `DD_ADMIN_PASSWORD`, `DD_ALLOWED_HOSTS`, `DD_DEBUG`.
  4. Depois de rodar: atualizar `Security-Scanner/README.md` — troca "não faz parte deste repo" por apontar pro `infra`.
- **Kubernetes: desenho fechado (k3s, 1 nó por cluster, Opção 3 — um cluster por projeto × ambiente, GitLab Kubernetes Agent — ver `docs-human/infra.md`), zero implementado ainda.**
  - **Lembrete seu:** você não conhece k3s/kubeadm ainda — quando a carga de um ambiente crescer, é fácil esquecer de escalar pra multi-nó a tempo. Ver se algum tipo de alerta de uso (CPU/memória do nó) vale a pena configurar cedo, já que ninguém mais vai notar isso por você.
  - **Lembrete seu (custo/manutenção cresce com Opção 3):** cada projeto novo = +3 clusters (qa/hml/master), +3 EC2, +3 registros de agente GitLab. Escolha consciente pelo isolamento total, mas com N projetos isso escala 3N — vale rever periodicamente se ainda compensa conforme os projetos crescem em número.
  - **Como sobem, decidido** (ver `docs-human/infra.md`): Postgres via CloudNativePG, Redis via Redis Operator (OT-ContainerKit), RabbitMQ via RabbitMQ Cluster Operator, Keycloak via Keycloak Operator — todos operators oficiais, gratuitos, sem Bitnami. Falta só implementar.
  - **Kit de bootstrap pronto, não implementado ainda** (passado no chat, guardar pra quando for publicar o 1º projeto de verdade): A) criar EC2 + instalar k3s (`curl -sfL https://get.k3s.io | sh -`); B) cert-manager + `ClusterIssuer` Let's Encrypt; C) registrar `.gitlab/agents/<nome>/config.yaml` + `helm install` do agente; D) instalar os 4 operators (CloudNativePG, Redis Operator, RabbitMQ Cluster Operator, Keycloak Operator); **E) segurança de cluster — `kube-bench` (CIS Kubernetes Benchmark) + Falco em DaemonSet, ver `docs/agents/kubernetes-security.md`.** Ordem A→B→C→D→E, repete por cluster (projeto×ambiente).
- **Fechado: `infra` virou consumível por projeto.** `docs/agents/infra-local.md` ganhou a seção "Nascimento de projeto novo" (banco Postgres dedicado, vhost RabbitMQ, realm Keycloak, ACL Redis restrita a `<projeto>:*`) e `docs-human/comandos-para-rodar.md` ganhou o passo 11 com os comandos reais de cada um.
- **Esclarecido: schema vs banco.** "Schema" no Postgres é isolamento por permissão dentro do mesmo banco (o que o `valuto` faz por módulo, ADR-002 dele, decisão interna do projeto — não regra do `ai-base`). "Banco" (database) é o isolamento forte, tipo instâncias que não se conhecem — é esse o nível que o `ai-base` garante: 1 banco por projeto, sempre.
- Decisão de usar AWS foi por visibilidade de mercado (vaga de DevOps/backend cita mais AWS), não por preço — já aplicada nas ADRs 006/007/015/016/019 do `valuto` (`backend/CLAUDE.md`), que antes citavam Azure.

## De observabilidade-backup.md

- **Fechado: log do .NET chega no Loki via Grafana Alloy** (não sink direto do Serilog, e não Promtail — Promtail é EOL desde março/2026, Alloy é o substituto oficial) — cobre .NET e não-.NET com um mecanismo só. Regra fixa pro .NET: log em JSON no console, isso é formato de saída, não arquitetura (ver `docs/agents/observabilidade-backup.md`).
- **Esclarecido: `ai-base` não fixa stack .NET, e isso é por design.** .NET como linguagem é fixo (você não vai trocar), mas framework/ORM/arquitetura (Clean Architecture, CQRS, o que for) é decisão de cada projeto — fixar isso no template seria "matar formiga com bazuca". O que o `ai-base` fixa são só os pontos de conexão com a infra compartilhada (log em JSON, `/health` via `HealthChecks`, banco por projeto) — isso não bloqueia mais nada.
- **Fechado:** retenção do Loki em 30 dias.
- **Fechado:** rotação do backup em 7 dumps diários + 4 semanais.
- **Fechado:** sync pro Google Drive via Google Drive for Desktop, pasta `G:\My Drive\ia` (passo 12 em `comandos-para-rodar.md`). Custo: coberto pelos 2TB do Google AI Plus (se você tiver) ou pelo grátis de 15GB — dump de Postgres pessoal não chega perto do limite.
- **Fechado: como Angular/.NET se autenticam via Keycloak é decisão de cada projeto, `ai-base` não fixa.** Mesmo raciocínio do schema do Postgres. O `valuto` já resolveu isso do jeito dele (ADR-003/004/005, `backend/src/Modules/Identity/CLAUDE.md`): módulo `Valuto.Identity` como fachada do Keycloak, padrão BFF/Token Handler (token real nunca chega no navegador, fica no Redis indexado por sessão opaca em cookie `httpOnly`). Fica registrado aqui como referência caso um projeto futuro queira reaproveitar o padrão — não é regra do template.
- Falta (não iniciado, deixado pro fim de propósito): runbook único de nascimento de projeto (amarrando esteira + infra + observabilidade numa sequência só).

## De orchestration.md

- Instalar `pi.dev`, autenticar Deepseek/OpenAI, instalar/montar painéis do Alethe — tudo isso já tirei do doc de IA porque é comando de terminal seu, já coberto em `docs-human/comandos-para-rodar.md` (passos 2, 3, 4, 6, 7).
- **Ideia registrada, não adotada:** Gas Town (`gastownhall/gastown`) automatiza uma camada acima do Alethe — uma fila de merge (Refinery) que valida e junta o trabalho de várias specs automaticamente, sem acompanhar terminal por terminal. Fica anotado como opção se o fluxo manual dos 4 painéis virar gargalo. Não pesquisei a fundo, só registrei o nome.

## De security-review.md (novo)

- **`kube-bench`/`pgdsat` — decidido usar, mas sem "onde roda" definido ainda.** `kube-bench` fica pro passo E do kit de Kubernetes (acima). `pgdsat` (CIS PostgreSQL Benchmark, `hexacluster/pgdsat`, GPLv3) não tem dependência de Kubernetes — pode rodar contra o Postgres compartilhado de hoje, mas ainda não decidi se roda manual (você, quando quiser auditar) ou vira job agendado tipo o `backup-postgres.ps1`. Registrado aqui até decidir.

## De ferramentas-por-custo.md (agora ui-ux.md)

- **Confirmar no seu tier Google AI Plus** se Stitch, Jules, Imagen dedicado e Whisk estão disponíveis — as fontes públicas não concordavam entre si, nenhuma é 100% confiável. Se Stitch estiver liberado, ele volta a fazer sentido como gerador inicial de conceito de tela.

## De referencias.md

- **"king.ai"**: não consegui identificar com segurança qual ferramenta era essa, num vídeo seu original de referência do workflow. Se lembrar/confirmar o nome certo, me manda que eu documento.
- **"flow" isolado** nesse mesmo vídeo original foi interpretado como Google Flow (contexto da lista mencionava `aistudio.google` logo depois) — se era outra ferramenta chamada "Flow", avisa que eu corrijo. Provavelmente já obsoleto, é de um vídeo antigo — pode ignorar se não lembrar mais do contexto.
