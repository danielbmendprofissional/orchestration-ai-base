# Biblioteca de componentes — recomendação por stack

Este template não fixa stack (item 1 do README), mas o **fluxo de design** precisa de uma recomendação prática de qualquer forma, porque uma task de `ui` sem biblioteca de base é o cenário onde mais aparece "ai-slop" (o modelo inventa componente do zero e cai em `rounded-2xl shadow-lg`, botão azul, etc. — ver `principios.md`).

## Se o projeto for React (o caso mais comum hoje pra web app/dashboard)

**Default: [shadcn/ui](https://ui.shadcn.com/).** Motivo: os componentes são copiados pro próprio repositório (não é uma dependência de node_modules fechada) — a task de `ui` edita o arquivo do componente diretamente quando precisa, sem lutar contra uma API de props fechada. Usa Radix por baixo (acessibilidade de verdade: foco, ARIA, teclado), e o visual é neutro o suficiente pra não empurrar pro "estilo shadcn padrão" (que é, ironicamente, um dos P0 do catálogo de ai-slop — então o tema shadcn default TEM que ser customizado com os tokens de `tokens.md`, nunca deixado como veio).

Alternativas, nesta ordem, se `shadcn/ui` não servir pro caso:

1. **HeroUI** — quando o projeto precisa de uma linguagem visual coesa "pronta" desde o primeiro componente (bom pra quando não vai dar tempo de customizar muito).
2. **Radix UI** puro (sem shadcn por cima) — quando já existe um design system rígido definido em `tokens.md`/Figma-like reference e só falta o primitivo acessível por baixo.
3. **Mantine** — só pra dashboards data-heavy (tabelas, filtros complexos); não usar em página de marketing, o visual "administrativo" não veste bem lá.

Evitar como default (não proibido, mas exige mais trabalho de customização pra não ficar genérico):
- **Material UI** — a estética Material é difícil de descaracterizar, os agentes tendem a reforçar o padrão Google.
- **Chakra UI** — funciona, mas menos alinhado ao momento de "vibe coding" que shadcn hoje.

## Se o projeto não for React

O princípio continua o mesmo (`avoid-ai-design` seção "Beyond HTML and React"): use a biblioteca de acessibilidade/primitivos madura do ecossistema daquele stack (ex: Radix-equivalente), nunca o tema/paleta default sem customização. Documente aqui a escolha quando o projeto definir o stack, seguindo o mesmo formato desta seção.

## Regra fixa, independente da biblioteca escolhida

Nenhuma biblioteca de componentes substitui `tokens.md` — ela é o *primitivo*, os tokens são a *decisão visual*. Um `<Button>` do shadcn com o tema default não customizado é P0 exatamente como um `<button>` HTML cru com Tailwind default.
