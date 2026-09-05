# Design tokens — ponto de partida

Este arquivo é um **starter**, não a resposta final: quando um projeto real nascer deste template e tiver uma marca/identidade definida, estes valores devem ser substituídos pelos tokens reais daquele projeto. O que fica fixo é a **estrutura** (ter uma escala, não valores soltos) — o `ui` (`.pi/agents/ui.md`) deve sempre consumir tokens daqui, nunca inventar um valor de cor/espaçamento ad-hoc no meio de uma task.

Formato neutro (JSON/CSS vars), pra não prender a um framework — quando o stack do projeto for escolhido, mapeie estes tokens pro idioma dele (`tailwind.config`, tema do styled-components, CSS custom properties, etc.) uma vez, no início do projeto.

## Cor

Evite o par roxo/azul de gradiente (P0 do catálogo de `avoid-ai-design`) como default não-escolhido. Escolha uma cor de marca real quando o projeto tiver uma; até lá, use esta paleta neutra como placeholder — ela existe pra não deixar a task de `ui` cair no azul/indigo de fábrica por preguiça:

```json
{
  "color": {
    "brand": {
      "50":  "#f4f7f5",
      "100": "#e3ebe6",
      "300": "#9bb8a8",
      "500": "#3d6b52",
      "700": "#274538",
      "900": "#132420"
    },
    "neutral": {
      "0":   "#ffffff",
      "50":  "#f7f7f6",
      "200": "#e2e1de",
      "500": "#7a7873",
      "800": "#2c2b28",
      "950": "#161513"
    },
    "feedback": {
      "success": "#2f7a4f",
      "warning": "#a3670c",
      "danger":  "#b3392c",
      "info":    "#2f6f8f"
    }
  }
}
```

## Tipografia

Nunca `Inter`/`Roboto`/system default sem essa ter sido uma decisão consciente (é o P0 nº1 do catálogo). Escolha uma combinação com pelo menos uma fonte de display quando o projeto justificar (marketing, landing); pra dashboards/app, prioriza legibilidade sobre personalidade, mas ainda assim escolhida, não default:

```json
{
  "typography": {
    "display": "Fraunces",
    "body": "Source Sans 3",
    "mono": "IBM Plex Mono",
    "scale": {
      "xs": "0.75rem",
      "sm": "0.875rem",
      "base": "1rem",
      "lg": "1.125rem",
      "xl": "1.25rem",
      "2xl": "1.5rem",
      "3xl": "1.875rem",
      "4xl": "2.25rem"
    }
  }
}
```

## Espaçamento

Escala geométrica, não "gap-4/p-6 uniforme em tudo" (P1 do catálogo — falta de ritmo):

```json
{
  "spacing": {
    "0": "0",
    "1": "0.25rem",
    "2": "0.5rem",
    "3": "0.75rem",
    "4": "1rem",
    "6": "1.5rem",
    "8": "2rem",
    "12": "3rem",
    "16": "4rem",
    "24": "6rem"
  }
}
```

## Raio e sombra

Não usar `rounded-2xl shadow-lg` em toda superfície por reflexo (P1). Ter no máximo 2-3 níveis, usados com intenção:

```json
{
  "radius": { "sm": "0.25rem", "md": "0.5rem", "lg": "0.75rem", "full": "9999px" },
  "shadow": {
    "sm": "0 1px 2px rgba(0,0,0,0.06)",
    "md": "0 4px 12px rgba(0,0,0,0.10)"
  }
}
```

## Movimento

Padrão: nenhum, a menos que a task de `ui` justifique. Se precisar, nunca o mesmo `fade-in-up` genérico em tudo (P2) — variar a transição conforme o contexto (entrada de modal ≠ hover de card ≠ toast).

## Quando o stack for definido

1. Copie os valores acima pro formato nativo do stack escolhido (Tailwind: `tailwind.config`; CSS puro: `:root { --color-brand-500: ... }`; etc.).
2. Apague este comentário e registre no `CONTEXT.md` do projeto que os tokens vivem naquele arquivo daqui pra frente — este `tokens.md` do template deixa de ser a fonte de verdade assim que o projeto real tiver a sua própria.
