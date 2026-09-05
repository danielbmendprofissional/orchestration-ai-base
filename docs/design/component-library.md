# Biblioteca de componentes — recomendação por stack

**Decisão fechada (não é mais "depende do projeto"): Angular é a stack fixa pra todo site/aplicativo web enterprise/SaaS deste template daqui pra frente.** React fica reservado só pra landing page isolada ou uso futuro pontual — não é mais o caso "mais comum" coberto por padrão neste arquivo.

## Default: Angular + PrimeNG

**[PrimeNG](https://primeng.org/)** é o default de componentes pra qualquer projeto Angular nascido deste template. Motivo: é a biblioteca Angular-nativa mais madura (não é port de algo React), cobre o catálogo inteiro que uma tela enterprise/dashboard pede (tabela com filtro/paginação/export, formulário completo, overlay, chart) e tem tema customizável via **PrimeNG Themes / Ultima Design Tokens** — o que significa que dá pra mapear `docs/design/tokens.md` direto pro tema do PrimeNG em vez de reescrever CSS na mão componente por componente.

Regra igual à que já valia pro shadcn/ui: **tema default do PrimeNG intocado é P0** (mesmo raciocínio do `principios.md` — todo default não escolhido é um "tell"). A task de `ui` sempre aplica o tema gerado a partir de `tokens.md`, nunca aceita a paleta "Aura"/"Lara" de fábrica sem customização de cor/tipografia/raio.

### Skills oficiais do Angular

Este projeto usa as **Agent Skills oficiais mantidas pelo time do Angular** (`github.com/angular/skills`, documentadas em `angular.dev/ai/agent-skills`), instaladas via:

```
npx skills add https://github.com/angular/skills
```

Duas skills relevantes:
- **`angular-developer`** — geração de código e orientação arquitetural: componentes standalone, signals, forms, injeção de dependência, roteamento, SSR, acessibilidade (ARIA), animações, estilo, testes, CLI. É a referência de "como se escreve Angular idiomático hoje" — as tasks `front` e `ui` devem tratar essa skill como fonte de verdade de convenção de código Angular, acima de qualquer hábito antigo (NgModules, RxJS-first sem necessidade, etc.).
- **`angular-new-app`** — bootstrap de projeto novo via Angular CLI com a estrutura moderna recomendada.

Comando de instalação real vai em `docs/comandos-para-rodar.md` (roda por projeto, não faz sentido instalar dentro do `ai-base` em si já que ele não é uma app Angular).

### Se o caso for React (landing page isolada ou uso futuro)

Continua valendo o que já estava documentado antes da mudança: **shadcn/ui** como default (componentes copiados pro repo, Radix por baixo, acessibilidade real), evitando Material UI/Chakra UI como default por reforçarem estética de fábrica difícil de descaracterizar. Isso só se aplica quando o próprio projeto justificou explicitamente ser uma landing/marketing separada do app Angular principal — nunca como fallback padrão pra tela de produto.

### Bibliotecas de referência (não pra copiar direto — Angular ≠ React)

`Aceternity UI`, `21st.dev` e `bklit UI` são catálogos de componentes **React/Tailwind** (bklit UI inclusive construído em cima do próprio shadcn/ui). Não dá pra instalar isso num projeto Angular. O uso correto aqui é **referência de padrão visual e de interação** (um card com hover específico, uma animação de entrada de dashboard, um jeito de estruturar um chart) — a task de `ui` reimplementa a ideia em Angular/PrimeNG/CSS, nunca importa o pacote React. Ver `referencias.md` pra a lista completa e o papel de cada site.

## Motion / animação

Duas bibliotecas cobrem o eixo de motion sem depender de React:
- **[anime.js](https://animejs.com/)** — motor de animação JS puro, sem dependência de framework, funciona dentro de um componente Angular controlando classe/estilo via `ElementRef`/`Renderer2`. Primeira escolha pra motion custom neste projeto.
- **[Motion](https://motion.dev/)** (ex-Framer Motion) — tem API "vanilla"/Web Animations além da integração React; se for usada em Angular, é só a parte vanilla (`motion` core), nunca os componentes React (`motion/react`).

Regra do `principios.md` continua valendo pra motion: nada de "fade-in-up" genérico repetido em tudo — ver seção de Movimento em `tokens.md`.

## Regra fixa, independente da biblioteca escolhida

Nenhuma biblioteca de componentes substitui `tokens.md` — ela é o *primitivo*, os tokens são a *decisão visual*. Um `p-button` do PrimeNG com o tema default não customizado é P0 exatamente como um `<button>` HTML cru com Tailwind default.
