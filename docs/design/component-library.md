# Biblioteca de componentes — recomendação por stack

**Angular é a stack fixa pra todo site/aplicativo web enterprise/SaaS deste template.** React fica reservado só pra landing page isolada ou uso futuro pontual.

## Default: Angular + spartan/ui + Tailwind

**[spartan/ui](https://www.spartan.ng/)** é o default de componentes pra qualquer projeto Angular nascido deste template (MIT, Angular 21+, Tailwind 4). Substituiu o PrimeNG, que deixou de ser MIT a partir da versão 22 — e o PrimeNG 21, último MIT, só aceita Angular 21. Duas camadas: `@spartan-ng/brain` (primitivas acessíveis sobre o Angular CDK, pacote npm) e o **helm** (o estilo), copiado pra `src/app/shared/ui` pela CLI — o código do componente é nosso. Componente novo: `npx ng g @spartan-ng/cli:ui <nome>`; import por `@spartan-ng/helm/<nome>`.

**[Tailwind CSS](https://tailwindcss.com/)** (MIT; pago é só o catálogo Tailwind Plus, que não usamos) estiliza o helm e o entorno (grid/flex da página, espaçamento entre componentes). Tokens com **fonte única** em `src/styles.css`: o `@theme` alimenta os utilitários e o `:root` traduz os mesmos valores pras variáveis que o helm lê (`--primary`, `--background`, `--border`…). Tailwind 4 não tem `tailwind.config`: o tema é CSS.

**Regra:** tema de fábrica do spartan (`stone`, `zinc`…) ou classe Tailwind de fábrica sem token por trás é P0. Variante nova de componente entra no próprio arquivo do helm (`cva`), não como classe solta na página.

### Skills oficiais do Angular

Skills mantidas pelo time do Angular (`github.com/angular/skills`), instaladas via `npx skills add https://github.com/angular/skills`:

- **`angular-developer`** — geração de código e orientação arquitetural: componentes standalone, signals, forms, injeção de dependência, roteamento, SSR, acessibilidade (ARIA), animações, estilo, testes, CLI. Fonte de verdade de convenção de código Angular pras tasks `front` e `ui`, acima de qualquer hábito antigo (NgModules, RxJS-first sem necessidade).
- **`angular-new-app`** — bootstrap de projeto novo via Angular CLI com estrutura moderna recomendada.

Instalação real (spartan/ui + Tailwind) roda por projeto, na configuração de ambiente daquele projeto — não faz parte do `ai-base` em si.

**Licença por versão:** antes de adotar ou subir a versão de qualquer biblioteca de UI, conferir a licença daquela versão no repositório — o campo `license` do npm do PrimeNG dizia "SEE LICENSE IN LICENSE.md" tanto nas versões MIT quanto nas comerciais.

### Se o caso for React (landing page isolada ou uso futuro)

**shadcn/ui** como default (componentes copiados pro repo, Radix por baixo, acessibilidade real). Evitar Material UI/Chakra UI como default. Só se aplica quando o projeto justificou explicitamente ser uma landing/marketing separada do app Angular principal — nunca como fallback pra tela de produto.

### Bibliotecas de referência (não pra copiar direto — Angular ≠ React)

`Aceternity UI`, `21st.dev` e `bklit UI` são catálogos de componentes **React/Tailwind**. Não dá pra instalar num projeto Angular. Uso correto: **referência de padrão visual e de interação** (um card com hover específico, uma animação de entrada de dashboard, um jeito de estruturar um chart) — a task de `ui` reimplementa a ideia em Angular/spartan/CSS, nunca importa o pacote React. Ver `referencias.md` pra lista completa e papel de cada site.

## Motion / animação

- **[anime.js](https://animejs.com/)** — motor de animação JS puro, controlando classe/estilo via `ElementRef`/`Renderer2`. Primeira escolha pra motion custom.
- **[Motion](https://motion.dev/)** (ex-Framer Motion) — usar só a API vanilla (`motion` core) em Angular, nunca os componentes React (`motion/react`).

Regra do `principios.md` vale igual pra motion: nada de "fade-in-up" genérico repetido em tudo — ver seção de Movimento em `tokens.md`.

### Interação custom sob pedido explícito (vídeo, scroll, cursor, o que for)

Quando o pedido envolve ligar algo visual a um evento do navegador (asset de vídeo, posição de scroll, posição do mouse, etc.), a implementação usa Angular nativo pro evento/asset (`<video>`, `HostListener` de scroll/mousemove, `ElementRef`/`Renderer2`, `IntersectionObserver`) combinado com `anime.js`/`Motion` pra suavizar o movimento resultante. Não existe uma lista fixa de "padrões aprovados" — qualquer combinação de evento do navegador + essas duas libs de motion está dentro do que este template já disponibiliza, sem precisar de lib nova.

## Regra fixa, independente da biblioteca escolhida

Nenhuma biblioteca de componentes ou utilitário de CSS substitui `tokens.md`. Um `hlmBtn` com as variáveis do tema de fábrica do spartan é P0, exatamente como uma classe Tailwind de fábrica (`bg-blue-500`, `rounded-2xl shadow-lg`) usada sem token por trás no `@theme`.