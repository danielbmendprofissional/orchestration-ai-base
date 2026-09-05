# Comandos pra rodar na sua máquina

Tudo que eu montei até agora e que precisa de uma ação sua fora do Cowork. Cada bloco diz **qual terminal** usar. Na dúvida sobre qual shell abrir: aperte a tecla Windows, digite o nome exato entre aspas de cada seção abaixo, e abra o resultado.

Ordem recomendada: 1 → 2 → 3 → 4 → 5 → 6 → 7.

---

## 1. Conferir pré-requisitos

**Terminal: "PowerShell" (normal, sem Administrador)**

```powershell
node -v
npm -v
git --version
```

Os três precisam responder com um número de versão (não "comando não encontrado"). Se algum faltar, me avisa antes de continuar — o resto dos comandos assume que os três já existem, já que você usa o OpenCode e o GitLab.

---

## 2. Instalar o pi.dev

**Terminal: "PowerShell" (normal primeiro)**

```powershell
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
```

Se der erro de permissão (`EACCES`, `EPERM`, "Access is denied"): feche esse PowerShell, abra de novo como **"PowerShell" clicando com botão direito → "Executar como administrador"**, e rode o mesmo comando só dessa vez. Depois pode voltar a usar o PowerShell normal pra tudo mais.

**Verificar que instalou** (PowerShell normal):

```powershell
pi --version
```

Precisa mostrar um número de versão (ex: `0.85.1` ou mais novo).

---

## 3. Autenticar Deepseek e GPT-5.6 Luna

Você vai precisar das chaves de API de cada provedor (não confundir com a assinatura que você já paga — isso aqui é a chave pra usar programaticamente):

- Deepseek: https://platform.deepseek.com/api_keys
- OpenAI (é lá que o GPT-5.6 Luna mora): https://platform.openai.com/api-keys

**Terminal: "PowerShell" (normal)** — grava a chave permanentemente pro seu usuário do Windows:

```powershell
setx DEEPSEEK_API_KEY "cole-sua-chave-deepseek-aqui"
setx OPENAI_API_KEY "cole-sua-chave-openai-aqui"
```

Importante: `setx` não afeta o PowerShell que já está aberto — **feche essa janela e abra uma nova** depois de rodar isso, senão o `pi` não vai ver as chaves.

Alternativa (se preferir não deixar a chave salva como variável de ambiente do Windows): dentro de uma sessão `pi` aberta, rode `/login deepseek` e `/login openai` — ele guarda em `~/.pi/agent/auth.json`, também permanente, sem precisar de `setx`.

---

## 4. Instalar o Alethe (o app dos 4 painéis)

**Sem terminal — é um instalador gráfico.**

1. Abra: https://github.com/Kc1t/alethe-agents/releases/latest
2. Baixe o arquivo `Alethe_<versão>_x64-setup.exe` (o mais recente da lista "Assets")
3. Dê duplo-clique e siga o instalador. Não deve pedir Administrador (é instalador por-usuário), mas se aparecer um aviso do Windows Defender SmartScreen ("Windows protegeu seu PC"), clique em "Mais informações" → "Executar assim mesmo" — é normal pra apps novos sem muitas instalações ainda, o projeto é open source e a release vem assinada.

---

## 5. Instalar o glab (CLI do GitLab)

Vai precisar disso mais pra frente, pro fluxo de issues/merge request funcionar de verdade (`docs/agents/issue-tracker.md`).

**Terminal: "PowerShell" (normal)**

```powershell
winget install GLab.GLab
```

**Autenticar** (mesmo terminal, depois de instalar — abre o navegador pra você logar):

```powershell
glab auth login
```

Escolha `gitlab.com`, depois "Login with a web browser" (ou "Token" se preferir colar um personal access token gerado em https://gitlab.com/-/user_settings/personal_access_tokens).

---

## 6. Testar tudo junto: rodar uma sessão `pi` no repo

**Terminal: "PowerShell" (normal)**

```powershell
cd "C:\Users\danib\source\repos\ai-base"
pi
```

Se abrir a interface do `pi` sem erro, deu tudo certo. Digite `/model` pra confirmar que `deepseek-v4-flash` e `gpt-5.6-luna` aparecem na lista (prova que a autenticação do passo 3 funcionou). Saia com `Ctrl+C` duas vezes ou `/exit`.

---

## 7. Montar os 4 painéis no Alethe

**Dentro do app Alethe (não é terminal solto)**

1. Abra o Alethe.
2. Crie um layout de grid com 4 painéis (a opção fica no menu de layout — "grid" ou "custom grid", 2x2).
3. Em cada painel, rode:

```powershell
cd "C:\Users\danib\source\repos\ai-base"
pi
```

Cada painel agora é uma sessão `pi` independente. Quando você tiver 4 specs prontas (fechadas por mim/Claude Code), abre uma branch de feature pra cada uma (`git checkout -b feature/<feature>/<spec>`) num painel diferente e usa `/implement-task <descrição da task>` — ver `docs/agents/orchestration.md` pros comandos de dentro da sessão `pi`.

---

## 8. Skills oficiais do Angular (nesta pasta `ai-base`, valem pro template todo)

**Terminal: "PowerShell" (normal)**, dentro da pasta do repo:

```powershell
cd "C:\Users\danib\source\repos\ai-base"
npx skills add https://github.com/angular/skills
```

Isso instala as skills `angular-developer` e `angular-new-app`. Não precisa `--all` nem `-a claude-code` aqui — se o instalador perguntar o agente-alvo, escolha só Claude Code, igual fizemos com as skills do Matt Pocock.

## 9. Cadeia de design anti-ai-slop — instala por PROJETO REAL, não aqui no template

Os dois comandos abaixo só fazem sentido dentro de um projeto Angular de verdade (com `npm start`/`ng serve` rodando em localhost), não dentro do `ai-base` (que não é uma aplicação). Guardo aqui só pra não perder o comando na hora certa.

**`ui-ux-pro-max-skill`** (motor de direção de design, 22 frameworks incluindo Angular):

```powershell
npm install -g ui-ux-pro-max-cli
uipro init --ai claude
```

**`impeccable.style`** (Node 22.12+ necessário — `node -v` deve mostrar 22.12 ou mais novo; se não, atualiza o Node antes):

```powershell
npx impeccable install
```

Depois, dentro de uma sessão do Claude Code aberta naquele projeto:

```
/impeccable init
/impeccable detect
/impeccable audit
```

E os comandos de correção conforme o `audit` indicar: `/impeccable adapt`, `/impeccable harden`, `/impeccable polish`.

**PrimeNG** (biblioteca de componentes Angular default — também por projeto, não aqui):

```powershell
npm install primeng @primeng/themes
```

**Tailwind CSS** (default junto com o PrimeNG, pra layout/espaçamento/utilitário — Angular 20+ tem suporte oficial):

```powershell
ng add tailwindcss
```

Se o `ng add` não existir ainda na versão do CLI do projeto, o caminho manual é `npm install tailwindcss @tailwindcss/postcss postcss` seguido da configuração descrita em `angular.dev/guide/tailwind` — mas tenta o `ng add` primeiro.

## O que eu NÃO coloquei aqui

`git push` continua proibido até você aprovar o que já foi commitado (`git log --oneline` mostra os commits locais). Nenhum comando desta lista dá push em nada.
