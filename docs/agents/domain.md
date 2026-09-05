# Domain Docs

Como as engineering skills devem consumir a documentação de domínio deste repo ao explorar o código.

## Antes de explorar, ler

- **`CONTEXT.md`** na raiz do repo, ou
- **`CONTEXT-MAP.md`** na raiz, se existir: aponta para um `CONTEXT.md` por contexto. Ler cada um relevante ao tópico.
- **`docs/adr/`**: ler ADRs que tocam a área em que você vai trabalhar.

Se algum desses arquivos não existir, **prosseguir em silêncio**. Não sinalizar a ausência; não sugerir criação antecipada. A skill `/domain-modeling` (alcançada via `/grill-with-docs` e `/improve-codebase-architecture`) cria isso preguiçosamente quando termos ou decisões realmente se resolvem.

## Estrutura de arquivos

Repo single-context (padrão deste projeto):

```
/
├── CONTEXT.md
├── docs/adr/
│   ├── 0001-....md
│   └── 0002-....md
└── src/
```

Se este repo virar um monorepo real (sinais: `pnpm-workspace.yaml`, `workspaces` no `package.json`, `packages/*` populado), migrar para o layout multi-context com `CONTEXT-MAP.md` na raiz e um `CONTEXT.md` por contexto em `src/<contexto>/`.

## Usar o vocabulário do glossário

Ao nomear um conceito de domínio (título de issue, proposta de refactor, hipótese, nome de teste), usar o termo como definido em `CONTEXT.md`. Não migrar para sinônimos que o glossário evita explicitamente.

## Sinalizar conflitos de ADR

Se sua saída contradiz uma ADR existente, sinalizar explicitamente em vez de sobrescrever silenciosamente.
