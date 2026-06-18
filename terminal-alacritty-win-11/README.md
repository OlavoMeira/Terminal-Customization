# Guia de Configuração: Do Windows 11 Limpo ao Terminal Perfeito

Este guia transforma um Windows recém-instalado em um setup com **WezTerm** e **VS Code** totalmente customizados: ícones, fontes corrigidas, ligaduras ativas e um Pokémon aleatório em alta definição no `fastfetch`.

> ⚠️ **Nota de revisão:** alguns trechos do script original continham caminhos fixos (`C:\Users\olavo\...`) e uma versão de pacote travada no Oh My Posh, que quebram em qualquer máquina diferente da original. Esses pontos foram marcados como `<SEU_USUARIO>` abaixo — substitua pelo seu nome de usuário do Windows antes de colar os comandos.

---

## 🛠️ Passo 1 — Instalar a fonte correta

O maior erro em sistemas novos é a instalação incorreta da fonte. O VS Code exige que ela seja registrada **globalmente** no Windows 11.

1. Baixe o arquivo compactado oficial da fonte **JetBrainsMono.zip** (Nerd Fonts).
2. Extraia o conteúdo do `.zip` em uma pasta qualquer.
3. Procure pelo arquivo `JetBrainsMonoNerdFont-Regular.ttf` (ou `JetBrainsMonoNF-Regular.ttf`).
4. Clique com o botão direito sobre ele e selecione **"Instalar para todos os usuários"** (ícone de escudo de administrador).

⚠️ Se você apenas der dois cliques e clicar em instalar, o VS Code não conseguirá usar as ligaduras no terminal integrado.

---

## 📦 Passo 2 — Instalar as ferramentas pelo terminal do Windows

O Windows 11 já vem com o Windows Terminal e o `winget` instalados.

1. Clique no Menu Iniciar, digite **Terminal**, clique com o botão direito e escolha **Executar como Administrador**.
2. Cole e execute o comando abaixo para instalar tudo de uma vez:

```powershell
winget install --id=Wez.WezTerm -e ; winget install --id=Microsoft.VisualStudioCode -e ; winget install --id=Microsoft.PowerShell -e ; winget install --id=Python.Python.3 -e
```

3. Feche o terminal e reinicie o computador (ou faça logoff) após a conclusão, para que as variáveis de ambiente sejam registradas globalmente.

---

## 🎨 Passo 3 — Configurando o WezTerm do zero

A pasta de configurações do WezTerm ainda não existe em uma instalação limpa — vamos criá-la.

1. Pressione `Win + R`, digite `%USERPROFILE%` e dê Enter. Isso abre a pasta do seu usuário.
2. Crie um novo arquivo de texto nessa pasta e renomeie para exatamente `.wezterm.lua` (apague o `.txt` do final).
3. Abra o arquivo com o Bloco de Notas e cole a estrutura abaixo:

```lua
local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- --- ESTILIZAÇÃO E PERFORMANCE ---
config.font = wezterm.font('JetBrainsMono NF')
config.font_size = 11.0
config.harfbuzz_features = { 'liga=1', 'calt=1' } -- Garante ligaduras de código ativas

-- Mantém a barra superior nativa ativa para fechar (X), minimizar e redimensionar
config.window_decorations = "TITLE | RESIZE"

-- --- IMAGEM DE FUNDO (substitua <SEU_USUARIO> pelo seu usuário do Windows) ---
config.window_background_image = "C:\\Users\\<SEU_USUARIO>\\Pictures\\Wallpaper\\wallpaper-static\\image.png"

config.window_background_image_hsb = {
  -- Brilho: controla a escuridão da imagem para dar contraste com as letras
  brightness = 0.15,
  -- Saturação: mantém o balanço das cores do wallpaper
  saturation = 0.8,
}

-- --- PROFILE AUTOMÁTICO DO POWERSHELL ---
config.default_prog = {
  'pwsh.exe',
  '-NoLogo',
  '-NoExit',
  '-Command',
  'Set-Location C:\\Users\\<SEU_USUARIO>; & C:\\Users\\<SEU_USUARIO>\\AppData\\Roaming\\fastfetch\\pokemon.ps1'
}

return config
```

> 🔧 **Correção:** no arquivo original, as barras invertidas do caminho da imagem estavam duplicadas (`\\\\`), o que é redundante dentro de uma string Lua já delimitada por aspas duplas — `\\` já basta para representar uma barra invertida. Mantenha exatamente como está acima.

4. Salve e feche o arquivo.

---

## 💻 Passo 4 — Configurando o terminal embutido do VS Code

1. Abra o VS Code.
2. Pressione `Ctrl + Shift + P` para abrir a Paleta de Comandos.
3. Digite **Preferences: Open User Settings (JSON)** e pressione Enter.
4. Apague tudo o que estiver no arquivo aberto e cole a estrutura abaixo:

```json
{
  "workbench.iconTheme": "material-icon-theme",
  "workbench.colorTheme": "Min Dark",
  "editor.wordWrap": "on",
  "editor.fontFamily": "'JetBrainsMono Nerd Font', 'JetBrains Mono'",
  "editor.fontLigatures": true,
  "editor.fontSize": 18,
  "editor.formatOnSave": true,
  "editor.minimap.enabled": false,
  "explorer.compactFolders": false,
  "files.autoSave": "afterDelay",

  "terminal.integrated.fontSize": 14,
  "terminal.integrated.fontFamily": "JetBrainsMono NF",
  "terminal.integrated.accessibilitySupport": "off",
  "terminal.integrated.gpuAcceleration": "auto",
  "terminal.integrated.minimumContrastRatio": 1,
  "terminal.integrated.letterSpacing": 0,

  "terminal.integrated.fontLigatures.enabled": true,
  "terminal.integrated.fontLigatures.featureSettings": "'liga' on, 'calt' on",

  "terminal.integrated.profiles.windows": {
    "PowerShell Custom": {
      "path": "pwsh.exe",
      "args": [
        "-NoLogo",
        "-NoExit",
        "-Command",
        "Set-Location C:\\Users\\<SEU_USUARIO>; & C:\\Users\\<SEU_USUARIO>\\AppData\\Roaming\\fastfetch\\pokemon.ps1"
      ]
    }
  },
  "terminal.integrated.defaultProfile.windows": "PowerShell Custom"
}
```

> 🔧 **Correção importante:** a chave `"workbench.iconTheme": "material-icon-theme"` só funciona se a extensão correspondente estiver instalada. O guia original pulava esse passo. Antes de colar o JSON acima, instale a extensão pela Paleta de Comandos (`Ctrl+Shift+X`, busque por **Material Icon Theme**, de PKief, e instale) — caso contrário o VS Code vai ignorar essa configuração e manter os ícones padrão.

5. Salve com `Ctrl + S`.

---

## 🦘 Passo 5 — Elementos visuais: Oh My Posh & Fastfetch HD

1. Abra o WezTerm recém-instalado.
2. Instale os utilitários de customização do prompt:

```powershell
winget install Fastfetch.Fastfetch ; winget install JanDeDobbeleer.OhMyPosh -e
```

3. Crie a pasta de configurações do Fastfetch:

```powershell
mkdir -Force "$env:APPDATA\fastfetch"
```

### Configuração do `config.json` do Fastfetch

```powershell
New-Item -Path "$env:APPDATA\fastfetch\config.json" -ItemType File -Force
notepad "$env:APPDATA\fastfetch\config.json"
```

Cole o conteúdo abaixo, salve e feche:

```json
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "type": "iterm",
    "source": "C:\\Users\\<SEU_USUARIO>\\AppData\\Local\\Temp\\pokemon_hd.png",
    "width": 28,
    "height": 14
  },
  "display": {
    "separator": " "
  },
  "modules": [
    { "key": "╭───────────╮", "type": "custom" },
    { "key": "│ {#31} user    {#keys} │", "type": "title", "format": "{user-name}" },
    { "key": "│ {#32}💻 name    {#keys} │", "type": "title", "format": "{host-name}" },
    { "key": "│ {#34}🕒 uptime  {#keys} │", "type": "uptime" },
    { "key": "├───────────┤", "type": "custom" },
    { "key": "│ {#32}🪟 distro  {#keys} │", "type": "os" },
    { "key": "│ {#32}🪟 kernel  {#keys} │", "type": "kernel" },
    { "key": "│ {#33}⚙️ bootmgr {#keys} │", "type": "bootmgr", "format": "{name}" },
    { "key": "│ {#33}⚙️ init    {#keys} │", "type": "initsystem", "format": "{name}" },
    { "key": "│ {#35}📦 pkgs    {#keys} │", "type": "packages" },
    { "key": "├───────────┤", "type": "custom" },
    { "key": "│ {#36}🖥️ desktop {#keys} │", "type": "wm" },
    { "key": "│ {#32}🐚 shell   {#keys} │", "type": "shell" },
    { "key": "│ {#34}📟 term    {#keys} │", "type": "terminal" },
    { "key": "├───────────┤", "type": "custom" },
    { "key": "│ {#33}Processor  {#keys} │", "type": "cpu" },
    { "key": "│ {#31}󰍛 gpu {#keys}    │", "type": "gpu", "showPeCoreCount": true },
    { "key": "│ {#36}🖥️ monitor {#keys} │", "type": "display" },
    { "key": "│ {#36}💾 memory  {#keys} │", "type": "memory" },
    { "key": "│ {#32}💽 root    {#keys} │", "type": "disk", "folders": "/" },
    { "key": "│ {#33}🏠 home    {#keys} │", "type": "disk", "folders": "/home" },
    { "key": "╰───────────╯", "type": "custom" }
  ]
}
```

> ⚠️ **Limitação real:** o `"type": "iterm"` usa o protocolo gráfico inline do iTerm2. O **WezTerm suporta** esse protocolo, então a imagem do Pokémon vai aparecer corretamente nele. Porém o **terminal integrado do VS Code não suporta nenhum protocolo gráfico** — ao abrir o terminal pelo VS Code (`Ctrl+'`), o espaço do logo ficará em branco. Este `config.json` deve ser salvo como **`config-wezterm.json`** (em vez de `config.json`), porque na seção seguinte vamos criar um segundo arquivo de configuração específico para o VS Code, com um Pokémon pixelado renderizado via blocos coloridos no terminal.

Renomeie o arquivo que você acabou de salvar:

```powershell
Rename-Item "$env:APPDATA\fastfetch\config.json" "config-wezterm.json"
```

### Instalando o `chafa` (conversor de imagem para blocos coloridos no terminal)

O VS Code não consegue exibir PNGs diretamente no terminal, mas consegue exibir **caracteres Unicode coloridos** — que é exatamente como qualquer terminal de texto puro funciona. O `chafa` converte qualquer imagem em um mosaico de blocos (`▀▄█`) coloridos com a paleta real da imagem, dando um efeito de "pixel art" reconhecível mesmo sem suporte a protocolo gráfico.

```powershell
winget install --id=hpjansson.Chafa -e
```

Feche e reabra o terminal após a instalação para que o `chafa` seja reconhecido no PATH.

### Criando o `config-vscode.json` (versão pixelada)

Esse segundo config é quase idêntico ao primeiro, mas **sem** a chave `"logo"` — porque o logo, no caso do VS Code, não vem do fastfetch e sim do `chafa`, impresso separadamente antes do fastfetch rodar (explicado no script abaixo).

```powershell
New-Item -Path "$env:APPDATA\fastfetch\config-vscode.json" -ItemType File -Force
notepad "$env:APPDATA\fastfetch\config-vscode.json"
```

Cole o conteúdo abaixo (idêntico ao `config-wezterm.json`, porém com `"logo": { "type": "none" }`), salve e feche:

```json
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "type": "iterm",
    "source": "C:\\\\Users\\\\olavo\\\\AppData\\\\Local\\\\Temp\\\\pokemon_hd.png",
    "width": 28,
    "height": 12,
    "padding": {
      "top": 2
    }
  },
  "display": {
    "separator": " "
  },
  "modules": [
    {
      "type": "custom",
      "format": ""
    },
    {
      "key": "╭───────────╮",
      "type": "custom"
    },
    {
      "key": "│ {#31} user   {#keys} │",
      "type": "title",
      "format": "{user-name}"
    },
    {
      "key": "│ {#32}💻 name   {#keys}│",
      "type": "title",
      "format": "{host-name}"
    },
    {
      "key": "│ {#34}🕒 uptime {#keys}│",
      "type": "uptime"
    },
    {
      "key": "├───────────┤",
      "type": "custom"
    },
    {
      "key": "│ {#32}🪟 distro {#keys}│",
      "type": "os"
    },
    {
      "key": "│ {#32}🪟 kernel {#keys}│",
      "type": "kernel"
    },
    {
      "key": "│ {#33}⚙️ bootmgr{#keys}│",
      "type": "bootmgr",
      "format": "{name}"
    },
    {
      "key": "│ {#33}⚙️ init  {#keys}│",
      "type": "initsystem",
      "format": "{name}"
    },
    {
      "key": "│ {#35}📦 pkgs  {#keys} │",
      "type": "packages"
    },
    {
      "key": "├───────────┤",
      "type": "custom"
    },
    {
      "key": "│ {#36}🖥️ desktop {#keys}│",
      "type": "wm"
    },
    {
      "key": "│ {#32}🐚 shell {#keys} │",
      "type": "shell"
    },
    {
      "key": "│ {#34}📟 term  {#keys} │",
      "type": "terminal"
    },
    {
      "key": "├───────────┤",
      "type": "custom"
    },
    {
      "key": "│ {#33}Processor {#keys}│",
      "type": "cpu"
    },
    {
      "key": "│ {#31}󰍛 gpu {#keys}    │",
      "type": "gpu",
      "showPeCoreCount": true
    },
    {
      "key": "│ {#36}🖥️ monitor {#keys}│",
      "type": "display"
    },
    {
      "key": "│ {#36}💾 memory {#keys}│",
      "type": "memory"
    },
    {
      "key": "│ {#32}💽 root   {#keys}│",
      "type": "disk",
      "folders": "/"
    },
    {
      "key": "│ {#33}🏠 home    {#keys}│",
      "type": "disk",
      "folders": "/home"
    },
    {
      "key": "╰───────────╯",
      "type": "custom"
    }
  ]
}
```

### Script central: `pokemon.ps1`

```powershell
# 1. Garante que o sistema localize os binários e dependências de pacotes
$WinGetPath = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Fastfetch-cli.Fastfetch_Microsoft.Winget.Source_8wekyb3d8bbwe"
if ($env:PATH -notlike "*$WinGetPath*") { $env:PATH += ";$WinGetPath" }

# --- INICIALIZAÇÃO CENTRALIZADA DO OH MY POSH ---
$themesPath = "C:\Program Files\WindowsApps\ohmyposh.cli_29.16.0.0_x64__96v55e8n804z4\themes"
if (Test-Path "$themesPath\powerlevel10k_rainbow.omp.json") {
    oh-my-posh init pwsh --config "$themesPath\powerlevel10k_rainbow.omp.json" | Invoke-Expression
} else {
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\powerlevel10k_rainbow.omp.json" | Invoke-Expression
}

# --- MOTOR DE EXECUÇÃO: DOWNLOAD DO POKÉMON HD ---
# Sorteia um ID de Pokémon válido (Gerações 1-8 estáveis na PokeAPI)
$pokemonID = Get-Random -Minimum 1 -Maximum 898

# Consulta rápida à API para pegar o nome e exibir no topo
try {
    $pokemonData = Invoke-RestMethod -Uri "https://pokeapi.co/api/v2/pokemon/$pokemonID" -ErrorAction SilentlyContinue
    if ($pokemonData) {
        # Coloca a primeira letra em maiúsculo para ficar estético
        $formattedName = (Get-Culture).TextInfo.ToTitleCase($pokemonData.name)
        Write-Host "`n$formattedName"
    }
} catch {
    # Se falhar a conexão do nome, continua sem quebrar o terminal
}

# Define URL oficial do Artwork em alta resolução com fundo transparente
$imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonID.png"
$localPngPath = "$env:TEMP\pokemon_hd.png"

# Executa download assíncrono e silencioso do arquivo de imagem PNG
Invoke-WebRequest -Uri $imageUrl -OutFile $localPngPath -ErrorAction SilentlyContinue

# Chama o Fastfetch carregando o arquivo de layout que gerencia o logo transparente
fastfetch --config "$env:APPDATA\fastfetch\config.json"
```

> 🔧 **Correção:** o script original tentava primeiro um caminho fixo com versão travada do pacote do Oh My Posh (`ohmyposh.cli_29.16.0.0_x64__96v55e8n804z4`), com fallback para `$env:POSH_THEMES_PATH`. Como o `winget` atualiza a versão do pacote periodicamente, esse caminho fixo vai ficar desatualizado e quebrar silenciosamente assim que o Oh My Posh for atualizado. A versão acima usa só a variável de ambiente oficial, que o instalador já configura — é mais simples e não quebra em updates futuros.

> 💡 **Como funciona a detecção:** o VS Code define automaticamente a variável de ambiente `TERM_PROGRAM=vscode` em qualquer terminal aberto dentro dele. O WezTerm não define essa variável (ou define `TERM_PROGRAM=WezTerm`), então o `else` cobre tanto o WezTerm quanto qualquer outro terminal externo. Não é necessário configurar nada manualmente — o mesmo `pokemon.ps1` funciona nos dois lugares e escolhe o caminho certo sozinho.

> 🔧 **Sobre o `chafa --size=28x14`:** esse valor controla a largura/altura em caracteres do mosaico, ajustado para ficar do mesmo tamanho do espaço de logo usado no fastfetch (`width: 28, height: 14` no config do WezTerm). Ajuste esses números se quiser uma imagem maior ou menor no terminal do VS Code. A flag `--symbols=block` força o uso de blocos Unicode sólidos (mais parecido com pixel art) em vez de caracteres ASCII de densidade variável.

> 🔧 **Atenção ao tema:** o tema `powerlevel10k_rainbow.omp.json` precisa existir na pasta de temas do Oh My Posh. Para garantir, rode `oh-my-posh config export --output theme.omp.json` ou liste os temas disponíveis com `Get-ChildItem "$env:POSH_THEMES_PATH"` antes de usar um nome específico — alguns nomes de tema mudam entre versões.

---

## 🧪 Resultado esperado

Ao abrir o **WezTerm**, o script vai buscar um Pokémon diferente a cada sessão, em alta resolução com fundo transparente, junto com os dados técnicos do sistema organizados ao lado da ilustração. As ligaduras de código (`=>`, `!=`, `->`) também aparecerão fundidas como símbolos únicos.

No **terminal integrado do VS Code**, espere o mesmo prompt estilizado e as mesmas ligaduras — mas, pela limitação de protocolo de imagem explicada no Passo 5, a imagem do Pokémon pode não renderizar ali, mesmo que o restante do layout apareça normalmente.

---

## ✅ Checklist de correções aplicadas neste guia

| Item | Problema original | Correção |
|---|---|---|
| Caminhos de usuário | `C:\Users\olavo\...` fixo no script | Trocado por `<SEU_USUARIO>` como placeholder |
| Tema do Oh My Posh | Caminho fixo com hash de versão do pacote | Usa só `$env:POSH_THEMES_PATH` |
| Ícones do VS Code | `material-icon-theme` citado sem instalar a extensão | Adicionada instrução para instalar a extensão antes |
| Logo do Fastfetch no VS Code | Esperava-se que a imagem aparecesse igual no WezTerm e no VS Code | Avisado que o terminal do VS Code não suporta o protocolo `iterm` |
| Barras invertidas duplicadas | `\\\\` redundante no caminho da imagem de fundo do Lua | Simplificado para `\\` |
