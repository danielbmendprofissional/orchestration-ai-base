# Issue tracker: GitLab

Issues e specs deste repo vivem como issues do GitLab (`gitlab.com/personal.daniel.bmend/ai-base`). Use a CLI [`glab`](https://gitlab.com/gitlab-org/cli) para todas as operações.

## Convenções

- **Criar issue**: `glab issue create --title "..." --description "..."`. Use heredoc para descrições multi-linha. `--description -` abre um editor.
- **Ler issue**: `glab issue view <number> --comments`. Use `-F json` para saída programática.
- **Listar issues**: `glab issue list -F json` com `--label` conforme necessário.
- **Comentar**: `glab issue note <number> --message "..."`. GitLab chama comentários de "notes".
- **Aplicar/remover labels**: `glab issue update <number> --label "..."` / `--unlabel "..."`.
- **Fechar**: `glab issue close <number>`. Como `glab issue close` não aceita comentário de fechamento, poste a explicação antes com `glab issue note`, depois feche.
- **Merge requests**: GitLab chama PRs de "merge requests". Use `glab mr create`, `glab mr view`, `glab mr note`, mesmo padrão do `gh pr ...` trocando `pr` por `mr` e `comment`/`--body` por `note`/`--message`.

`glab` infere o repo a partir de `git remote -v` quando rodado dentro do clone.

## Merge requests como superfície de triagem

**MRs como superfície de request: não.** _(Mude para `sim` se este repo tratar MRs externos como feature requests; `/triage` lê essa flag.)_

## Quando uma skill diz "publicar no issue tracker"

Criar uma issue no GitLab.

## Quando uma skill diz "buscar o ticket relevante"

Rodar `glab issue view <number> --comments`.

## Operações de wayfinding

Usadas por `/wayfinder`. O **map** é uma issue única com issues **filhas** como tickets.

- **Map**: issue única com label `wayfinder:map`, contendo o corpo Notes / Decisions-so-far / Fog. `glab issue create --label wayfinder:map`.
- **Ticket filho**: issue com `Part of #<map>` no topo da descrição e labels `wayfinder:<type>` (`research`/`prototype`/`grilling`/`task`). Ao ser reivindicado, atribuído ao dev que está tocando.
- **Bloqueio**: link nativo de bloqueio do GitLab via quick action `/blocked_by #<n>`, postado como note. É recurso Premium/Ultimate; no tier free, usar linha `Blocked by: #<n>, #<n>` no topo da descrição. Ticket desbloqueia quando todos os bloqueadores fecham.
- **Frontier query**: `glab issue list -F json` filtrado nas filhas do map, descartando as com bloqueador aberto ou assignee; a primeira na ordem do map vence.
- **Claim**: `glab issue update <n> --assignee @me`, a primeira escrita da sessão.
- **Resolve**: `glab issue note <n> --message "<resposta>"`, depois `glab issue close <n>`, depois anexar um ponteiro de contexto às Decisions-so-far do map.
