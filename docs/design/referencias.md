# Catálogo de referências (vídeo do usuário + pesquisa complementar)

Lista completa dos sites/ferramentas citados como referência do workflow de design, com o papel real de cada um neste template (Angular-fixo). "Ferramenta consultável" = um agente pode chamar/ler programaticamente. "Inspiração visual" = referência humana, reimplementada manualmente em Angular, nunca copiada como pacote.

| Site/ferramenta | O que é | Papel aqui |
|---|---|---|
| [dark.design](https://www.dark.design/) | Galeria de inspiração de UI em dark mode | Inspiração visual — paleta/composição em dark mode |
| [Aceternity UI](https://ui.aceternity.com/) | Catálogo de componentes React + Tailwind, muito animado | Inspiração visual/interação — reimplementar em Angular/PrimeNG + anime.js/Motion, nunca importar o pacote React |
| [21st.dev](https://21st.dev/) | Marketplace de componentes React ("shadcn-like") | Mesmo papel do Aceternity: inspiração, não dependência |
| [PrimeNG](https://primeng.org/) | Biblioteca de componentes **Angular nativa** | **Default de componentes deste template** — ver `component-library.md` |
| [bklit UI](https://bklit.com/) (`github.com/bklit/bklit-ui`) | Biblioteca de charts/data-viz React, construída sobre shadcn/ui | Inspiração pra visualização de dados densa (dashboard) — reimplementar com a lib de chart Angular do projeto (ex: PrimeNG Charts/Chart.js), nunca o pacote React |
| [anime.js](https://animejs.com/) | Motor de animação JS puro | **Ferramenta usável direto em Angular** — ver seção Motion em `component-library.md` |
| [Motion](https://motion.dev/) (ex-Framer Motion) | Biblioteca de animação; tem API vanilla e integração React | Usar só a API vanilla (`motion` core) em Angular; os componentes `motion/react` não se aplicam |
| [interfaces.rauno.me](https://interfaces.rauno.me/) | Checklist de boas práticas de interface web (não é galeria) | **Ferramenta consultável** — checklist de interação/acessibilidade/motion, ver `principios.md` |
| [lazyweb.com](https://www.lazyweb.com/) | Pesquisa de padrão de produto via MCP, base de telas reais + testes A/B | **Ferramenta consultável via MCP** (`lazyweb.com/mcp/public`) — ver `principios.md` |
| Google AI Studio (aistudio.google.com) | Console de acesso aos modelos/produtos Google AI (Gemini, Imagen, Veo) | Acesso aos produtos abaixo (Stitch, Flow) dentro da assinatura Google AI Plus do usuário |
| Google **Stitch** | Ferramenta Google de geração de UI por IA (prompt → tela, canvas de até 5 telas), formato de saída referenciado como "DESIGN.md" — o mesmo formato que o `impeccable init` gera | Uso opcional no início de uma spec nova pra gerar um primeiro conceito visual antes de implementar em Angular; o `DESIGN.md` gerado pelo Stitch pode alimentar o `/impeccable init` do projeto em vez de escrever esse arquivo do zero |
| Google **Flow** | Ferramenta Google de geração de vídeo por IA (composição de cenas, câmera, continuidade) | Fora do fluxo de código — útil só pra vídeo de demonstração/pitch do produto, não gera UI |
| [Vercel](https://vercel.com/) | Plataforma de deploy + ecossistema de design (v0, Next.js) | Referência de discurso de design "bom" (o padrão que o mercado usa como benchmark) e plataforma padrão se algum dia uma landing React deste template precisar de deploy próprio — não é dependência do fluxo Angular |
| Figma (free tier) | Ferramenta de design tradicional | Uso pontual, não obrigatório — ver seção final de `principios.md` |

## Itens não confirmados / não integrados

- **"king.ai"**: não foi possível identificar com segurança qual ferramenta o vídeo referenciava com esse nome — as buscas só retornam apps de geração de vídeo/imagem genéricos sem relação clara com o resto do workflow (design system, Angular, etc.). Não foi integrado a este documento nem ao fluxo. Se o usuário confirmar a ferramenta certa (link direto), este arquivo é atualizado.
- **"flow"** isolado (item 2.3.9 da lista original) foi tratado como **Google Flow** (item da assinatura Google AI Plus, seção acima), dado o contexto do restante da lista mencionar `aistudio.google` logo depois. Se o vídeo se referia a outra ferramenta chamada "Flow", sinalizar pra corrigir aqui.
