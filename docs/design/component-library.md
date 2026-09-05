# Biblioteca de componentes — recomendação por stack

**Decisão fechada (não é mais "depende do projeto"): Angular é a stack fixa pra todo site/aplicativo web enterprise/SaaS deste template daqui pra frente.** React fica reservado só pra landing page isolada ou uso futuro pontual — não é mais o caso "mais comum" coberto por padrão neste arquivo.

## Default: Angular + PrimeNG + Tailwind

**[PrimeNG](https://primeng.org/)** é o default de componentes pra qualquer projeto Angular nascido deste template. Motivo: é a biblioteca Angular-nativa mais madura (não é port de algo React), cobre o catálogo inteiro que uma tela enterprise/dashboard pede (tabela com filtro/paginação/export, formulário completo, overlay, chart) e tem tema customizável via **PrimeNG Themes / Ultima Design Tokens** — o que significa que dá pra mapear `docs/design/tokens.md` direto pro tema do PrimeNG em vez de reescrever CSS na mão componente por componente.

**[Tailwind CSS](https://tailwindcss.com/)** entra como default junto do PrimeNG, não como alternativa: Angular tem suporte oficial a Tailwind desde a v20 (`angular.dev/guide/tailwind`), e o papel dele aqui é cobrir o que o PrimeNG não resolve — layout (grid/flex da página), espaçamento entre componentes, e ajuste fino de utilitário sem precisar escrever CSS/SCSS customizado pra cada tela. PrimeNG cuida do componente em si (o `p-button`, o `p-table`); Tailwind cuida do entorno (como os componentes se organizam na página). Configuração: `tailwind.config` mapeado a partir de `tokens.md` (cor, espaçamento, tipografia) igual ao que já valia pro caso React — aqui os dois (preset do PrimeNG e `tailwind.config`) precisam bater com os mesmos valores, nunca um com o token e o outro com o default de fábrica.

Regra igual à que já valia pro shadcn/ui: **tema default do PrimeNG intocado, ou classe Tailwind de fábrica sem token por trás, é P0** (mesmo raciocínio do `principios.md` — todo default não escolhido é um "tell"). A task de `ui` sempre aplica o tema gerado a partir de `tokens.md` nos dois (preset PrimeNG e `tailwind.config`), nunca aceita a paleta "Aura"/"Lara" de fábrica do PrimeNG nem a paleta default do Tailwind sem customização de cor/tipografia/raio.

### Skills oficiais do Angular

Este projeto usa as **Agent Skills oficiais mantidas pelo time do Angular** (`github.com/angular/skills`, documentadas em `angular.dev/ai/agent-skills`), instaladas via:

```
npx skills add https://github.com/angular/skills
```

Duas skills relevantes:
- **`angular-developer`** — geração de código e orientação arquitetural: componentes standalone, signals, forms, injeção de dependência, roteamento, SSR, acessibilidade (ARIA), animações, estilo, testes, CLI. É a referência de "como se escreve Angular idiomático hoje" — as tasks `front` e `ui` devem tratar essa skill como fonte de verdade de convenção de código Angular, acima de qualquer hábito antigo (NgModules, RxJS-first sem necessidade, etc.).
- **`angular-new-app`** — bootstrap de projeto novo via Angular CLI com a estrutura moderna recomendada.

Comandos de instalação reais (PrimeNG + Tailwind) vão em `docs/comandos-para-rodar.md` (rodam por projeto, não faz sentido instalar dentro do `ai-base` em si já que ele não é uma app Angular).

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

Nenhuma biblioteca de componentes ou utilitário de CSS substitui `tokens.md` — eles são o *primitivo*, os tokens são a *decisão visual*. Um `p-button` do PrimeNG com o tema default não customizado é P0 exatamente como uma classe Tailwind de fábrica (`bg-blue-500`, `rounded-2xl shadow-lg`) usada sem passar pelo `tailwind.config` mapeado dos tokens.
