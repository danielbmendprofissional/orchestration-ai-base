# Ferramentas de design por custo — o que usar e quando

Você já paga por Claude Code/Claude.ai, Deepseek V4 Flash, GPT-5.6 Luna e Google AI Plus (assinatura de 1 ano). A regra deste arquivo é simples: **a maior parte do trabalho de design deste fluxo deve caber dentro do que você já paga** — custo marginal zero. Ferramenta fora disso só entra quando cobre algo que nenhuma das já pagas cobre, e mesmo assim começando pelas gratuitas antes de qualquer coisa que gere custo extra.

Isso complementa `component-library.md` (o que usar pra código/componente) e `principios.md` (a cadeia anti-ai-slop) — este arquivo é especificamente sobre **onde gastar esforço/dinheiro** em cada etapa.

## Camada 0 — já pago fixo (Claude Code), custo marginal zero, usar à vontade

- **Todas as skills do Matt Pocock + `avoid-ai-design`**, já instaladas neste repo.
- **Skill de Design do Claude Code** (Claude Design — canvas de artboards editável): use pra desenhar wireframe/mockup de uma tela antes de virar código Angular, sobretudo quando precisar alinhar com você mesmo ou com alguém não-técnico. É o substituto direto do papel que eu tinha reservado ao Figma free-tier — mesma função, mas sem sair do Claude Code e sem os limites de arquivo do Figma grátis.
- **Skill de Dataviz do Claude Code**: quando a task envolver dashboard/gráfico, use pra decidir paleta/formato/tipo de gráfico antes de implementar em PrimeNG Charts — evita reinventar heurística de cor/layout de gráfico na mão.
- **Deepseek V4 Flash / GPT-5.6 Luna via pi.dev** — a camada de execução já decidida (`docs/agents/orchestration.md`).
- **PrimeNG, skills oficiais do Angular, anime.js, Motion (API vanilla)** — bibliotecas open-source, zero custo.
- **`interfaces.rauno.me`** — checklist gratuito de boas práticas de interface.

## Camada 1 — Google AI Plus, já pago (assinatura de 1 ano), dentro da cota mensal

Confirmado por você que geração de imagem e vídeo (Gemini + Flow) já funcionam na prática, então uso liberado dentro da cota:

- **Nano Banana / Nano Banana Pro** (dentro do Gemini app) — geração/edição de imagem: ícone, ilustração, hero image, imagem de fundo, asset de apoio pra uma task de `ui`.
- **Flow + Veo 3.1 Fast** — vídeo curto: demo de produto ao final de uma feature, teaser, ou referência de motion pra reimplementar depois com `anime.js`/`Motion` (o vídeo em si nunca vira o produto final, é referência ou material de divulgação).
- **NotebookLM** — sintetizar pesquisa (ex: transformar o que saiu de `lazyweb.com` ou de uma varredura de concorrência num resumo em áudio/relatório).
- **Gemini 3 Pro (chat)** — segunda opinião de discovery/brainstorm, quando fizer sentido comparar com o que o Claude Code já produziu.

Regra: usar à vontade dentro da cota mensal — a assinatura já está paga fixo pro ano inteiro, então não usar é desperdício, não economia. Se a cota mensal de algum item (ex: vídeos/dia do Flow) acabar antes do fim do ciclo, a tarefa espera o próximo mês em vez de forçar upgrade de tier só por isso.

## Camada 2 — gratuito, mas fora de qualquer assinatura (instala/cadastra à parte, sem cobrança)

- `ui-ux-pro-max-skill` (MIT, instalação local)
- `impeccable.style` (grátis hoje; tier Pro é anunciado como futuro, ainda não lançado)
- `lazyweb.com` (MCP público, grátis)
- Figma tier gratuito (uso pontual, ver limite de arquivos em `principios.md`)
- Skills oficiais do Angular (open source, `github.com/angular/skills`)

## Camada 3 — geraria custo adicional ou não está confirmado no seu tier — evitar sem necessidade clara

- Créditos extra de Google AI além da cota do Plus (implicaria upgrade pra Pro/Ultra)
- Stitch, Jules, Imagen dedicado, Whisk — status no tier Plus não confirmado (ver `referencias.md`); não planejar o fluxo em cima deles até você confirmar disponibilidade real na sua conta
- Figma pago — já descartado desde a decisão original

## Como decidir na prática

| Preciso de... | Uso isto primeiro |
|---|---|
| Layout de wireframe pra alinhar antes do código | Claude Design (Camada 0) |
| Ícone/ilustração/imagem de apoio pra UI | Nano Banana no Gemini (Camada 1) |
| Vídeo de demo/pitch curto | Flow + Veo 3.1 Fast (Camada 1) |
| Direção de paleta/tipografia/estilo pra uma tela nova | `ui-ux-pro-max-skill` (Camada 2) |
| Auditoria de ai-slop no app rodando | `impeccable.style` (Camada 2), com `avoid-ai-design` (Camada 0) como rede rápida no `/code-review` |
| Padrão de interação validado empiricamente | `interfaces.rauno.me` / `lazyweb.com` (Camada 0/2) |
| Gráfico/dashboard | Skill de Dataviz do Claude Code (Camada 0) pra definir, PrimeNG Charts (Camada 0) pra implementar |
| Discussão de tela com alguém não-técnico | Claude Design (Camada 0) primeiro; Figma free só se a pessoa já preferir Figma especificamente |

Regra geral quando não estiver na tabela: **Camada 0 > Camada 1 > Camada 2 > Camada 3**, nessa ordem, a não ser que a ferramenta de uma camada mais cara resolva algo que nenhuma das anteriores resolve de verdade (não é "essa é mais chique", é "essa é a única que cobre isso").
