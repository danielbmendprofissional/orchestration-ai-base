# RTK + Caveman — instalação e configuração aprovada

Detalhe técnico de instalação/ativação. Para o *porquê* de cada decisão (benchmarks, cenários de uso), ver `less-tokens.md` neste mesmo diretório — este arquivo só existe pra separar "o que fazer" de "por que fazer".

## RTK

Já instalado globalmente na máquina (`cargo install --git https://github.com/rtk-ai/rtk` ou `brew install rtk`).

Vinculado ao OpenCode via:

```bash
rtk init -g --opencode
```

Sem configuração por projeto necessária — atua como proxy de saída de terminal a nível global. Verificar status com `rtk gain` (tratar como termômetro, não como fatura real — ver seção 1 de `less-tokens.md`).

Regra: manter **ligado** nos 3 cenários de uso (Claude Code discovery/arquitetura, OpenCode/execução, Claude Code design/review) — é onde ele tem chance real de ajudar (grep/read de saída de comando), e o pior caso medido foi neutro, não negativo.

## Caveman

Já instalado globalmente em `~/.config/opencode/` (ou equivalente do Claude Code — confirmar path local com `ls ~/.caveman`).

Ativação por sessão:

```
/caveman [level]
```

Níveis: `full` (prosa-pesada, Q&A), `off` (código-pesado). Confirmar efeito real da sessão com `/caveman-stats` no fim — não assumir o número de marketing.

### Regra por cenário (decisão fechada)

| Cenário | RTK | Caveman |
|---|---|---|
| Discovery / arquitetura / specs (Claude Code) | ligado | `/caveman full` |
| Execução de código (Deepseek/Luna via OpenCode) | ligado | desligado (`/caveman off` — não validado no OpenCode, e é o perfil onde mediu líquido negativo) |
| Design / review / testes (Claude Code) | ligado | misto: `full` na discussão de review, `off` durante bateria de testes |

## Monitoramento

Semanal: `/usage` (Claude Code) + `opencode stats --days 7` (OpenCode).
Mensal: `/insights` (Claude Code) + `opencode stats` all-time, cruzando com a fatura real da Anthropic/provider — os painéis internos das ferramentas não substituem isso.
