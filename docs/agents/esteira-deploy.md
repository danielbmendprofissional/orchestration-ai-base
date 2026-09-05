# Esteira de deploy: dev → qa → hml → master

Registro da decisão de como o `ai-base` (e os projetos nascidos dele) vai promover código entre ambientes. Decidido em conversa com Daniel em 2026-09-05, a partir do que já existe implementado e testado em `template-ci` (repo separado, `C:\Users\danib\source\repos\template-ci`, `gitlab.com/personal.daniel.bmend/template-ci`). Este documento só registra a decisão — **não foi implementado ainda**, nem aqui nem lá.

## Decisão 1 — Mecanismo de reuso: include remoto, não cópia

O `ai-base` (e cada projeto derivado) vai consumir a esteira via `include:` do GitLab CI apontando pro `template-ci`, em vez de copiar os arquivos YAML pra dentro de cada projeto. Motivo: evita duplicar a lógica de promoção/gates entre o `template-ci` e todo projeto futuro — uma correção no gate feita uma vez beneficia todo mundo.

Isso cria uma dependência real entre repositórios, que precisa de disciplina de versionamento:

- O `include:` deve fixar uma **tag** do `template-ci` (ex: `ref: v1.0.0`), nunca `main`/`master` direto — senão uma mudança no `template-ci` pode quebrar o pipeline de produção de qualquer projeto consumidor sem aviso.
- **Pendência nova, ainda não decidida em nenhum dos dois repos:** o `template-ci` hoje não tem disciplina própria de release/tag — os commits vão direto pra `main`/`master`, sem `vX.Y.Z`. Antes do primeiro `include:` real, o `template-ci` precisa adotar pra si mesmo o mesmo esquema de tag que ele aplica aos projetos consumidores. Sem isso não há `ref:` estável pra fixar. Ver pendência espelhada em `template-ci/README.md`.
- Sintaxe esperada (a confirmar quando o primeiro projeto derivado existir):
  ```yaml
  include:
    - project: 'personal.daniel.bmend/template-ci'
      ref: v1.0.0
      file: 'personal/ci-template.yml'
  ```
  Os dois repos já estão no mesmo GitLab (`gitlab.com`, namespace `personal.daniel.bmend`), então o include entre projetos é tecnicamente viável hoje — só falta o `template-ci` publicar a primeira tag.

## Decisão 2 — Escopo de stack a consumir: Angular + .NET

O `ai-base` tem Angular fixo no frontend; backend ainda não tem stack fixa (ver `CLAUDE.md`), mas a decisão foi já preparar o .NET junto, sem esperar essa escolha fechar. Arquivos de `template-ci/personal/` que entram no escopo:

- `common/controlar-pipeline.yml`, `common/rules.yml` — o gate de sequência/anti-contrabando de tag, reaproveitado como está.
- `security/` inteiro (`sast.yml`, `secret-detection.yml`, `semgrep.yml`, `trivy.yml`, `common/security.yml`) e `report/report.yml` — bloqueio por severidade HIGH/CRITICAL.
- `build/`, `test/`, `deploy/` de `angular.yml` e `dotnet.yml`; `smoke-test/angular.yml`.
- `banco/` (`common/review.yml`, `rollback.yml`, `rollout.yml`) — **incluído no escopo** (decisão revista em 2026-09-05): projetos nascidos do `ai-base` podem precisar de esteira de migração de banco desde o início, não só projetos legados.
- `ci-template.yml` / `ci-execucao.yml` como esqueleto de include, adaptados pra remover os pontos de extensão de Java que não se aplicam aqui.

**Fora do escopo por enquanto:** só `java.yml` (build/deploy/test) — fica no `template-ci`, específico de projetos que ainda usam essa stack (ex.: TCE, via `tce/`). Se um projeto nascido do `ai-base` precisar de Java algum dia, revisitar aí.

**Pré-requisito antes de portar o .NET:** o `template-ci` hoje usa `WebPublishMethod=MSDeploy` (build e deploy acoplados, rebuild completo por ambiente) — ver `template-ci/docs/melhorias.md`. A decisão aqui foi portar já a versão "Package" (build once, deploy many, igual ao `dist/` do Angular), não a atual. Ou seja: **essa melhoria precisa ser implementada no `template-ci` antes do `ai-base` apontar o include pra ela.**

## Decisão 3 — Modelo de promoção: por tag

A promoção `dev → qa → hml → master` é disparada por tag (`vX.Y.Z` / `vX.Y.Z-rcN`), igual ao `template-ci` — não por merge direto de MR. Reaproveita como está:

- O gate de sequência do `controlar-pipeline.yml` (só promove se a tag candidata vier do estágio imediatamente anterior no `STAGE_CHAIN`; barra rollback fora de ordem e contrabando de commit).
- Aprovação manual (`when: manual`) em toda transição de ambiente, não só em produção.
- Bloqueio por severidade (SAST/Secret Detection/Trivy/Semgrep sem HIGH/CRITICAL).
- Smoke test pós-deploy (hoje só cobre Angular, via `APP_ENVIRONMENT_URL`; .NET fica de fora até ganhar uma variável equivalente).

**Em aberto — quem cria a tag e quando:** hoje, no `template-ci`, a tag é criada manualmente (não existe job de CI que tagueia sozinho). A proposta de partida pro `ai-base` é a mesma: depois que a MR pra `dev` é aprovada e mergeada (fim do fluxo descrito em `docs/workflow.md`), Daniel cria a tag manualmente pra disparar a primeira promoção. **Isso ainda não foi confirmado explicitamente na conversa — tratar como proposta até fechar.**

## Como isso conecta com `docs/workflow.md`

O diagrama de `docs/workflow.md` hoje termina em "merge request → dev (branch protegida) → validação humana → esteira promove". Falta o passo intermediário: quem cria a tag que efetivamente aciona a esteira. Ajustar o diagrama quando a Decisão 3 acima for confirmada — ver nota deixada lá.

## Pendências, na ordem em que provavelmente serão retomadas

1. `template-ci` adotar disciplina própria de tag/release (bloqueia a Decisão 1).
2. `template-ci` implementar o .NET Package (bloqueia a metade .NET da Decisão 2; a metade Angular já pode ser portada sem esperar isso).
3. Confirmar a Decisão 3 (quem/quando cria a tag) e atualizar `docs/workflow.md`.
4. Só então montar o `.gitlab-ci.yml` do `ai-base` com o `include:` de verdade — trabalho de implementação, fora do escopo deste documento.

## Referências

- `template-ci/README.md` — estado atual do pipeline (commit `1eee043` na data desta decisão).
- `template-ci/docs/melhorias.md` — backlog, inclui a melhoria do .NET Package (pré-requisito da Decisão 2).
- `docs/agents/orchestration.md` deste repo — mesmo padrão de "camada documentada à parte", usado aqui pra esteira de deploy.
