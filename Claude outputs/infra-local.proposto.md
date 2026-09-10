# Infra local: serviços de contexto + segurança

## Modelo: infra compartilhada, não por projeto

Uma instância só, permanente, de Postgres/Redis/RabbitMQ/Keycloak (repo `infra`, `docker-compose.yml`). Todo projeto aponta sua connection string pra essa instância — nunca sobe container próprio.

Um Postgres compartilhado, um banco por projeto dentro dele. Nunca uma instância Postgres por projeto. O que acontece dentro do banco de cada projeto — schema por módulo, tabela solta, o que for — é decisão interna daquele projeto, não regra do `ai-base` (o `valuto` optou por schema+role por módulo, isso é ADR do `valuto`, não obrigação geral).

## Nascimento de projeto novo

Todo projeto novo ganha, na mesma infra compartilhada:

- **Postgres:** 1 banco `<projeto>` dedicado (nunca reaproveita banco de outro projeto). Organização interna do banco é decisão do projeto.
- **RabbitMQ:** 1 vhost `<projeto>` dedicado.
- **Keycloak:** 1 realm `<projeto>` dedicado.
- **Redis:** 1 ACL user `<projeto>` restrito a `<projeto>:*` (ver comando em `docs-human/comandos-para-rodar.md`).

Cada projeto novo ganha seu próprio `banco/<projeto>/init-db.sql` dentro do repo `infra`, sem sobrescrever os existentes.

## Segurança de banco e runtime (Docker Compose, ambiente atual)

Duas lacunas que o `ai-base` não cobria até agora, cobertas em `docs/agents/security-review.md` só do lado de código/skill — aqui é o lado de infra rodando de verdade:

**pgAudit — log de auditoria do Postgres.** A imagem `postgres:17-alpine` usada hoje no `infra/container/docker-compose.yml` não vem com a extensão `pgaudit` pronta — precisa de imagem customizada (`Dockerfile` a partir de `postgres:17-alpine` compilando/instalando `pgaudit`) ou trocar pra uma imagem que já empacota a extensão. Uma vez ligada (`shared_preload_libraries = 'pgaudit'` + `pgaudit.log` nas envs do serviço `postgres`), o log de auditoria cai automaticamente no Grafana que já existe — o `alloy` já capta log de **todo** container Docker via `docker.sock` (`container/alloy-config.alloy`), sem precisar de pipeline novo. Se o projeto for migrar pra Kubernetes com CloudNativePG (ver `docs/agents/kubernetes-security.md`), isso fica mais barato de ligar lá — avaliar se vale a pena fazer duas vezes (Docker agora + CNPG depois) ou esperar a migração.

**Falco — runtime security do host/containers.** Diferente de Trivy/Checkov (que escaneiam imagem/manifesto antes de rodar), o Falco monitora o que está rodando de verdade e alerta comportamento anômalo em tempo real — funciona em Docker puro, não precisa esperar o Kubernetes. Reaproveita o mesmo `/var/run/docker.sock` que o `alloy` já monta. Esboço de serviço pro `docker-compose.yml` (a confirmar na hora — Falco publica imagem oficial e muda de tag com frequência):

```yaml
falco:
  image: falcosecurity/falco:latest
  container_name: falco
  restart: unless-stopped
  privileged: true
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock:ro
    - /proc:/host/proc:ro
    - /boot:/host/boot:ro
    - /lib/modules:/host/lib/modules:ro
    - /usr:/host/usr:ro
  networks:
    - infra-network
```

`privileged: true` é necessário pro Falco enxergar syscall do kernel — isolar esse serviço mentalmente do resto (é o único da lista com esse nível de acesso). Saída dele pode ir por `stdout` (cai no Loki automático, igual pgAudit) ou por um output plugin dedicado — decidir na hora de implementar.

## Nuvem de produção: AWS

- **Secrets:** Kubernetes Secrets nativo pra começar; evoluir pra HashiCorp Vault self-hosted (dentro do `infra`) só se rotação/auditoria justificar depois. Nunca AWS Secrets Manager.
- **Registry de imagem e pacote:** GitLab Container Registry / GitLab Package Registry, não ECR.
- **Mensageria em produção:** RabbitMQ self-hosted, mesmo broker de dev — não Amazon MQ.
- Deploy roda em Kubernetes (provisionamento em `docs-human/infra.md` — não muda como o código é escrito). Segurança específica de cluster (CIS Kubernetes Benchmark, `kube-bench`, Falco em modo DaemonSet) fica em `docs/agents/kubernetes-security.md` — não se aplica ainda, só quando o cluster existir.

## Observabilidade e backup

Ver `docs/agents/observabilidade-backup.md`.
