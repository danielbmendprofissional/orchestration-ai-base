# Princípios de design deste projeto

Decisão fechada pro item "fluxo de design" do README: **sem Figma, sem Penpot, code-first**. Você mesmo apontou que o Figma dá trabalho manual demais pro seu caso — então este projeto não tem uma etapa separada de mockup visual antes do código. O design acontece dentro do próprio fluxo TDD+SDD (`docs/workflow.md`), na task de `ui` (`.pi/agents/ui.md`), guiado por três coisas: os tokens deste diretório, a biblioteca de componentes certa pro stack do projeto (`component-library.md`), e a skill `avoid-ai-design` auditando o resultado antes de fechar a task.

Se um dia um projeto específico precisar de um lugar pra desenhar/discutir tela com alguém que não mexe em código, [Penpot](https://penpot.app) (open source, gratuito, sem instalar nada pesado) é a opção — mas isso é exceção pontual, não o fluxo padrão.

## A regra central: default não escolhido é o "tell"

Isso vem direto da skill `avoid-ai-design` (`.claude/skills/avoid-ai-design/`, ver `references/ai-tells-catalog.md` lá dentro pro catálogo completo). Resumo pra quem só quer a regra prática:

Um gradiente roxo-azul não é ruim porque roxo é ruim — é ruim porque ninguém escolheu, foi o reflexo do modelo. A mesma lógica vale pra fonte, espaçamento, ícone, cópia. Toda escolha visual da task de `ui` precisa ser **intencional**, referenciando um dos tokens/decisões abaixo, nunca "o que o framework colocou por padrão".

## O que NUNCA passa sem justificativa explícita (P0 — qualquer pessoa reconhece como "feito por IA")

- Gradiente roxo-pro-azul, texto com `bg-clip-text`
- Fonte `Inter`/`Roboto`/system default sem ter sido uma escolha de `tokens.md`
- Tema padrão do shadcn/ui intocado
- Glassmorphism reflexivo
- Hero centralizado + três cards de feature (o "template de SaaS genérico")

## O que precisa de atenção mas é mais tolerável (P1 — dev/designer reconhece)

- `rounded-2xl shadow-lg` em toda superfície sem variação
- Shell de página padrão (`container mx-auto px-4`, `max-w-7xl`) sem ajuste
- Ícone-dentro-de-quadrado-arredondado repetido
- Botão azul/indigo "de fábrica"
- Cópia tipo "Elevate your workflow", "Seamless", "Powerful" sem substância

## Perfil por tipo de tela (ajusta o quanto isso importa)

| Perfil | Como tratar |
|---|---|
| `dashboard` / `app-component` (o mais comum aqui, ver decisão de "web app/dashboard") | Passe cirúrgico: prioriza densidade, legibilidade e hierarquia de informação sobre decoração. Corrige os tells óbvios, não reinventa o componente inteiro. |
| Landing/marketing (mais raro neste template) | Força total — aqui uma direção visual ousada vale a pena de verdade. |
| Dentro de um design system já existente | Só cirúrgico, respeita os tokens que já existem, nunca briga com o sistema. |

## Fluxo prático

1. A task de `ui` (`.pi/agents/ui.md`) sempre lê `tokens.md` e `component-library.md` antes de escrever qualquer classe/estilo.
2. Ao terminar, a task de `ui` roda `/skill:avoid-ai-design detect` nela mesma (a skill está disponível tanto no Claude Code quanto nas sessões `pi`, via `.pi/settings.json`) — se aparecer P0, corrige antes de devolver pro agente pai.
3. No `/code-review` final do Claude Code (`docs/workflow.md`), qualquer diff que toque UI roda `/skill:avoid-ai-design detect` de novo, como segunda camada — o dual-check da task de `ui` pode ter deixado passar algo, ou o subagent pode ter ignorado a instrução.
4. Acessibilidade não é opcional em nenhum perfil: `:focus-visible` ausente é sempre alta prioridade, mesmo fora do P0/P1/P2.
