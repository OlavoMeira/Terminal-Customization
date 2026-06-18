# Guia de Configuração: Do Windows 11 Limpo ao Terminal Perfeito

Este guia vai transformar um Windows recém-instalado no setup com WezTerm e VS Code totalmente customizados, com ícones, fontes corrigidas, ligaduras ativas e um Pokémon aleatório no fastfetch.

## 🛠️ Passo 1: O Coração de Tudo — Instalar a Fonte Correta
O maior erro em sistemas novos é a instalação incorreta da fonte. O VS Code exige que ela seja registrada globalmente no Windows 11.

1. Baixe o arquivo compacto oficial da fonte: **JetBrainsMono.zip** (Nerd Fonts).
2. Extraia o conteúdo do arquivo `.zip` em uma pasta qualquer.
3. Procure pelo arquivo específico **JetBrainsMonoNerdFont-Regular.ttf** (ou **JetBrainsMonoNF-Regular.ttf**).
4. **Clique com o botão direito** sobre ele e selecione "**Instalar para todos os usuários**" (ícone de escudo de administrador).

⚠️ *Se você apenas der dois cliques e clicar em instalar, o VS Code não conseguirá usar as ligaduras no terminal integrado.*

---

## 📦 Passo 2: Instalar as Ferramentas pelo Terminal do Windows
O Windows 11 já vem com o Windows Terminal e o winget (gerenciador de pacotes nativo) instalados. Vamos usá-los para instalar o WezTerm, o VS Code, a versão moderna do PowerShell e o Python (necessário para os scripts do Pokémon).

1. Clique no Menu Iniciar, digite **Terminal**, clique com o botão direito nele e escolha **Executar como Administrador**.
2. Cole e execute o comando abaixo para instalar tudo de uma vez:

```powershell
winget install --id=Wez.WezTerm -e ; winget install --id=Microsoft.VisualStudioCode -e ; winget install --id=Microsoft.PowerShell -e ; winget install --id=Python.Python.3 -e
```

3. **Feche o terminal e reinicie o computador (ou faça Logoff)** após a conclusão para que as variáveis de ambiente do Python e dos novos terminais sejam registradas no sistema.

---

## 🎨 Passo 3: Configurando o WezTerm do Zero
Como o sistema é novo, a pasta de configurações do WezTerm ainda não existe. Vamos criá-la.

1. Pressione as teclas **Win + R**, digite **%USERPROFILE%** e dê Enter. Isso abrirá a pasta do seu usuário.
2. Crie um novo arquivo de texto nessa pasta e renomeie-o exatamente para **.wezterm.lua** (certifique-se de apagar o `.txt` do final).
3. Abra o arquivo **.wezterm.lua** com o Bloco de Notas e cole a estrutura abaixo:

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

-- --- IMAGEM DE FUNDO (Altere para o caminho da sua imagem) ---
config.window_background_image = "C:\\Users\\olavo\\Pictures\\Wallpaper\\wallpaper-static\\image.png"

config.window_background_image_hsb = {
  -- Brilho (brightness): Controla a escuridão da imagem para dar contraste com as letras
  brightness = 0.15,
  -- Saturação (saturation): Mantém o balanço das cores do wallpaper
  saturation = 0.8,
}

-- --- PROFILE AUTOMÁTICO DO POWERSHELL ---
config.default_prog = { 
  'pwsh.exe', 
  '-NoLogo', 
  '-NoExit', 
  '-Command', 
  'Set-Location C:\Users\olavo; & C:\Users\olavo\AppData\Roaming\fastfetch\pokemon.ps1' 
}

return config
```
4. Salve e feche o arquivo.

---

## 💻 Passo 4: Configurando o Terminal Embutido do VS Code
Com o motor moderno do VS Code, precisamos usar as chaves explícitas para impedir que ele tente emular ligaduras usando imagens parciais.

1. Abra o VS Code.
2. Pressione **Ctrl + Shift + P** para abrir a Paleta de Comandos.
3. Digite: **Preferences: Open User Settings (JSON)** e pressione Enter.
4. Apague tudo o que estiver no arquivo aberto e cole a nossa estrutura cirúrgica e sem duplicidades:

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
  
  // --- MOTOR DO TERMINAL INTEGRADO ---
  "terminal.integrated.fontSize": 14,
  "terminal.integrated.fontFamily": "JetBrainsMono NF",
  "terminal.integrated.accessibilitySupport": "off",
  "terminal.integrated.gpuAcceleration": "auto",
  "terminal.integrated.minimumContrastRatio": 1,
  "terminal.integrated.letterSpacing": 0,
  
  // Correção das linhas cinzas/apagadas: Chaves com pontos atualizadas
  "terminal.integrated.fontLigatures.enabled": true,
  "terminal.integrated.fontLigatures.featureSettings": "'liga' on, 'calt' on",

  // Inicialização idêntica ao WezTerm com o script do Pokémon
  "terminal.integrated.profiles.windows": {
    "PowerShell Custom": {
      "path": "pwsh.exe",
      "args": [
        "-NoLogo",
        "-NoExit",
        "-Command",
        "Set-Location C:\Users\olavo; & C:\Users\olavo\AppData\Roaming\fastfetch\pokemon.ps1"
      ]
    }
  },
  "terminal.integrated.defaultProfile.windows": "PowerShell Custom"
}
```
5. Salve com **Ctrl + S**.

---

## 🦘 Passo 5: Adicionando os Elementos Visuais (Oh My Posh & Fastfetch)
Para a nova instalação exibir o visual completo (as setas coloridas na linha de comando e o sumário com o Pokémon), instale os utilitários de customização do prompt.

1. Abra o seu recém-instalado WezTerm (ele vai abrir apontando erro no script do Pokémon provisoriamente, ignore).
2. Instale o Fastfetch, o Oh My Posh e a biblioteca de Pokémons rodando os comandos abaixo:

```powershell
winget install Fastfetch.Fastfetch ; winget install JanDeDobbeleer.OhMyPosh -e
pip install pokemon-colorscripts
```

3. Feche o WezTerm e abra-o novamente para carregar todas as ferramentas no sistema.

### Criando a Pasta de Configurações
No WezTerm, crie a pasta onde as configurações do Fastfetch residem:
```powershell
mkdir -Force "$env:APPDATA\fastfetch"
```

### Configuração Personalizada do Fastfetch (JSON)
Para ter um visual mais estruturado e com ícones no Fastfetch, como uma "caixa" de informações, vamos criar o arquivo de layout JSON.

1. Crie o arquivo `config.json`:
```powershell
New-Item -Path "$env:APPDATA\fastfetch\config.json" -ItemType File -Force
notepad "$env:APPDATA\fastfetch\config.json"
```

2. Cole o seguinte conteúdo no arquivo `config.json`, salve e feche:
```json
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "type": "none"
  },
  "display": {
    "separator": " "
  },
  "modules": [
    {
      "key": "╭───────────╮",
      "type": "custom"
    },
    {
      "key": "│ {#31} user    {#keys} │",
      "type": "title",
      "format": "{user-name}"
    },
    {
      "key": "│ {#32}💻 name    {#keys} │",
      "type": "title",
      "format": "{host-name}"
    },
    {
      "key": "│ {#34}🕒 uptime  {#keys} │",
      "type": "uptime"
    },
    {
      "key": "├───────────┤",
      "type": "custom"
    },
    {
      "key": "│ {#32}🪟 distro  {#keys} │",
      "type": "os"
    },
    {
      "key": "│ {#32}🪟 kernel  {#keys} │",
      "type": "kernel"
    },
    {
      "key": "│ {#33}⚙️ bootmgr {#keys} │",
      "type": "bootmgr",
      "format": "{name}"
    },
    {
      "key": "│ {#33}⚙️ init    {#keys} │",
      "type": "initsystem",
      "format": "{name}"
    },
    {
      "key": "│ {#35}📦 pkgs    {#keys} │",
      "type": "packages"
    },
    {
      "key": "├───────────┤",
      "type": "custom"
    },
    {
      "key": "│ {#36}🖥️ desktop {#keys} │",
      "type": "wm"
    },
    {
      "key": "│ {#32}🐚 shell   {#keys} │",
      "type": "shell"
    },
    {
      "key": "│ {#34}📟 term    {#keys} │",
      "type": "terminal"
    },
    {
      "key": "├───────────┤",
      "type": "custom"
    },
    {
      "key": "│ {#33}Processor  {#keys} │",
      "type": "cpu"
    },
    {
      "key": "│ {#31}Graphics   {#keys} │",
      "type": "gpu",
      "showPeCoreCount": true
    },
    {
      "key": "│ {#36}🖥️ monitor {#keys} │",
      "type": "display"
    },
    {
      "key": "│ {#36}💾 memory  {#keys} │",
      "type": "memory"
    },
    {
      "key": "│ {#32}💽 root    {#keys} │",
      "type": "disk",
      "folders": "/"
    },
    {
      "key": "╰───────────╯",
      "type": "custom"
    }
  ]
}
```

### Configuração do Script Central (Pokémon Aleatório + Oh My Posh)
Agora, vamos criar o arquivo unificado `pokemon.ps1`. Ele fará o trabalho completo de preparar os caminhos, inicializar o tema visual e selecionar um Pokémon diferente a cada boot.

1. Crie o arquivo executável:
```powershell
New-Item -Path "$env:APPDATA\fastfetch\pokemon.ps1" -ItemType File -Force
notepad "$env:APPDATA\fastfetch\pokemon.ps1"
```

2. Cole o script avançado abaixo dentro dele, salve e feche:
```powershell
# 1. Garante que o sistema localize os binários e dependências de pacotes
$WinGetPath = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Fastfetch-cli.Fastfetch_Microsoft.Winget.Source_8wekyb3d8bbwe"
$PokemonPath = "C:\Program Files\PokemonColorScripts"

if ($env:PATH -notlike "*$WinGetPath*") { $env:PATH += ";$WinGetPath" }
if ($env:PATH -notlike "*$PokemonPath*") { $env:PATH += ";$PokemonPath" }

# --- INICIALIZAÇÃO CENTRALIZADA DO OH MY POSH ---
$themesPath = "C:\Program Files\WindowsApps\ohmyposh.cli_29.16.0.0_x64__96v55e8n804z4\themes"
if (Test-Path "$themesPath\powerlevel10k_rainbow.omp.json") {
    oh-my-posh init pwsh --config "$themesPath\powerlevel10k_rainbow.omp.json" | Invoke-Expression
} else {
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\powerlevel10k_rainbow.omp.json" | Invoke-Expression
}

# --- SCRIPT DE POKÉMON ALEATÓRIO NO FASTFETCH ---
$list = (pokemon-colorscripts -List 2>&1) | Where-Object { $_ -match '^\w' } | ForEach-Object { $_.Trim() }
$randomName = $list | Get-Random

$prev = [Console]::OutputEncoding
[Console]::OutputEncoding = [Text.UTF8Encoding]::new($false)
$sprite = pokemon-colorscripts -Name $randomName
[Console]::OutputEncoding = $prev

[System.IO.File]::WriteAllLines("$env:TEMP\pokemon.txt", $sprite, [Text.UTF8Encoding]::new($false))
fastfetch --config "$env:APPDATA\fastfetch\config.json" --logo "$env:TEMP\pokemon.txt" --logo-type file-raw --logo-width 22 --logo-height 12
```

---

## 🧪 O Resultado Esperado
Feche absolutamente todas as janelas do seu computador. Ao abrir o **WezTerm** ou o terminal integrado do **VS Code** (`Ctrl + '`), o Windows 11 limpo carregará o PowerShell moderno exibindo um Pokémon aleatório em pixel art, os dados da sua máquina dentro de uma caixa estilizada e o prompt do Oh My Posh perfeitamente alinhado. Ao digitar `->` ou `!=`, as ligaduras de código se fundirão imediatamente!