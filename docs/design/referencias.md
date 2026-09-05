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
| Google AI Studio (aistudio.google.com) | Console de desenvolvedor pra modelos Gemini (API key, protótipo de prompt, "build" apps) | **Não depende da assinatura Google AI Plus** — é gratuito por conta Google separadamente (billing por uso de API se passar do tier free). Útil pra prototipar uma chamada de API ou testar um prompt de geração de imagem fora do fluxo do Gemini app. |

### O que a assinatura Google AI Plus (o plano pago mais barato, não Pro/Ultra) realmente cobre pra design/UI/UX

Pesquisei tier por tier porque você está certo em desconfiar — eu tinha listado Stitch e Flow meio "de ouvido", sem checar se são features de Plus ou só aparecem no Pro/Ultra. As fontes públicas (blogs de terceiros, não a página oficial de pricing) **não concordam entre si nos números exatos**, então trato isso como direção, não como garantia — a fonte de verdade é o que aparece liberado dentro da sua própria conta em `gemini.google.com`/`one.google.com`.

Com razoável confiança, **incluído no Plus**:
- **Gemini 3 Pro** (com teto de uso mais baixo que o Pro/Ultra, janela de contexto ~128K) — útil pra discovery/brainstorm de spec, não só GPT/Deepseek.
- **Nano Banana / Nano Banana Pro** (geração e edição de imagem dentro do próprio Gemini app) — o item mais aproveitável pra este fluxo: gerar imagem de referência/hero/ícone/moodboard rápido pra alimentar a task de `ui`, sem precisar de Midjourney/Imagen separado.
- **Flow** (ferramenta de "filmmaking" por IA, usa Veo por baixo) — presente no Plus, mas com cota de créditos mensal limitada, não uso livre.
- **Veo 3.1 Fast** dentro do Gemini app/Flow — só a variante "Fast" e com cota diária baixa (as fontes citam algo entre 2 vídeos/dia); a versão "Lite"/completa do Veo parece ficar pro Pro/Ultra.
- **NotebookLM** com limites ampliados (mais notebooks, fontes, audio/video overview por dia) — útil pra sintetizar pesquisa de design/concorrência em um resumo em áudio pro time.

**Incerto / provavelmente NÃO incluído no Plus** (múltiplas fontes sugerem que fica no Pro/Ultra, mas nenhuma é 100% autoritativa):
- **Stitch** — não achei confirmação de que está disponível já no tier Plus; várias fontes nem citam Stitch na lista do Plus. **Antes de desenhar o fluxo em cima dele, confirme dentro da sua conta se o Stitch aparece disponível.**
- **Jules** (agente de código assíncrono do Google) — as fontes só mencionam Jules com cota no Pro (5×) e Ultra (20×), nenhuma cita cota no Plus. Se não estiver disponível, ele não entra como opção adicional de execução ao lado do Deepseek/GPT-5.6 Luna já decididos.
- **Imagen** dedicado (separado do Nano Banana) — parece mais restrito/ausente no Plus.
- **Whisk** (remix de imagem por referência visual) — status no Plus não ficou claro nas fontes consultadas.
- **Google Antigravity** (plataforma de desenvolvimento "agent-first" do Google, sucessora do Gemini CLI) — aparece como destaque do tier Ultra ($100), não do Plus.

### Como isso muda o uso prático de Google AI Plus neste projeto

Dado o que está mais confirmado, o uso realista da sua assinatura no fluxo de design fica assim: **Nano Banana/Nano Banana Pro** pra gerar imagem de apoio (ícone, ilustração, imagem de hero) que a task de `ui` usa como referência ou asset direto; **Flow/Veo 3.1 Fast** pra um vídeo curto de demonstração/pitch quando uma spec terminar (fora do fluxo de código, não gera UI); **NotebookLM** pra sintetizar a pesquisa feita em `interfaces.rauno.me`/`lazyweb.com` num resumo consumível. Se você confirmar que Stitch está mesmo liberado na sua conta, ele volta a fazer sentido como gerador inicial de conceito de tela (o papel que eu tinha descrito antes) — só não assumo isso mais sem essa confirmação sua.
| [Vercel](https://vercel.com/) | Plataforma de deploy + ecossistema de design (v0, Next.js) | Referência de discurso de design "bom" (o padrão que o mercado usa como benchmark) e plataforma padrão se algum dia uma landing React deste template precisar de deploy próprio — não é dependência do fluxo Angular |
| Figma (free tier) | Ferramenta de design tradicional | Uso pontual, não obrigatório — ver seção final de `principios.md` |

## Itens não confirmados / não integrados

- **"king.ai"**: não foi possível identificar com segurança qual ferramenta o vídeo referenciava com esse nome — as buscas só retornam apps de geração de vídeo/imagem genéricos sem relação clara com o resto do workflow (design system, Angular, etc.). Não foi integrado a este documento nem ao fluxo. Se o usuário confirmar a ferramenta certa (link direto), este arquivo é atualizado.
- **"flow"** isolado (item 2.3.9 da lista original) foi tratado como **Google Flow** (item da assinatura Google AI Plus, seção acima), dado o contexto do restante da lista mencionar `aistudio.google` logo depois. Se o vídeo se referia a outra ferramenta chamada "Flow", sinalizar pra corrigir aqui.
