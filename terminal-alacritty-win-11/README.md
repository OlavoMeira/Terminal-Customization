# Projeto: Pokémon Aleatório no Fastfetch com Alacritty (Windows 11)

Este projeto visa configurar o `fastfetch` para exibir um Pokémon aleatório em ASCII toda vez que um novo terminal Alacritty for aberto no Windows 11, utilizando o PowerShell 7.

## Visão Geral

A configuração padrão do `fastfetch` para exibir imagens pode não funcionar diretamente com o Alacritty no Windows. A solução proposta envolve o uso do `pokemon-colorscripts-py` para gerar a arte ASCII do Pokémon e um script do PowerShell para integrar isso ao `fastfetch`.

## Pré-requisitos

Certifique-se de ter os seguintes componentes instalados em seu sistema Windows 11:

*   **Python 3:** Necessário para o `pokemon-colorscripts-py`.
    *   Verifique se o Python está no seu PATH. Caso contrário, instale-o (ex: via [python.org](https://www.python.org/downloads/windows/) ou [Scoop](https://scoop.sh/)).
*   **pip:** Gerenciador de pacotes do Python (geralmente vem com o Python).
*   **fastfetch:** Ferramenta de informações do sistema.
    *   Instale-o seguindo as instruções oficiais do [fastfetch-cli](https://github.com/fastfetch-cli/fastfetch).
*   **Alacritty:** Emulador de terminal rápido e moderno.
    *   Instale-o a partir do [GitHub do Alacritty](https://github.com/alacritty/alacritty/releases).
*   **PowerShell 7 (pwsh):** Versão mais recente do PowerShell.
    *   Instale-o a partir do [GitHub do PowerShell](https://github.com/PowerShell/PowerShell/releases).

## Estrutura do Projeto

```
fastfetch_pokemon_project/
├── config.jsonc
├── pokemon.ps1
├── alacritty.toml
└── README.md
```

## Instalação e Configuração

Siga os passos abaixo para configurar seu ambiente:

### Passo 1: Instalar `pokemon-colorscripts-py`

Abra o PowerShell 7 e execute o seguinte comando para instalar a biblioteca Python:

```powershell
pip install pokemon-colorscripts-py
```

Para testar se a instalação foi bem-sucedida, execute:

```powershell
pokemon-colorscripts --random
```

Você deverá ver um Pokémon aleatório em ASCII no seu terminal.

### Passo 2: Configurar o `fastfetch`

O arquivo `config.jsonc` do `fastfetch` precisa ser modificado para usar o Pokémon gerado como logo. Substitua o conteúdo do seu arquivo `config.jsonc` (geralmente localizado em `%APPDATA%\fastfetch\config.jsonc` ou `%USERPROFILE%\.config\fastfetch\config.jsonc`) pelo conteúdo do arquivo `config.jsonc` fornecido neste projeto. **Lembre-se de substituir `SEU_USUARIO` pelo seu nome de usuário do Windows.**

**`config.jsonc`**
```json
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "type": "file-raw",
    "source": "C:\\Users\\SEU_USUARIO\\AppData\\Local\\Temp\\pokemon.txt",
    "padding": {
      "top": 2,
      "left": 1,
      "right": 3
    }
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
      "key": "│ {#31}\uf007 user   {#keys} │",
      "type": "title",
      "format": "{user-name}"
    },
    {
      "key": "│ {#32}\uf109 name   {#keys} │",
      "type": "title",
      "format": "{host-name}"
    },
    {
      "key": "│ {#34}\uf017 uptime {#keys} │",
      "type": "uptime"
    },
    {
      "key": "├───────────┤",
      "type": "custom"
    },
    {
      "key": "│ {#32}\uf303 distro {#keys} │",
      "type": "os"
    },
    {
      "key": "│ {#32}\uf17c kernel {#keys} │",
      "type": "kernel"
    },
    {
      "key": "│ {#33}\uf013 bootmgr{#keys} │",
      "type": "bootmgr",
      "format": "{name}"
    },
    {
      "key": "│ {#33}\uf423 init   {#keys} │",
      "type": "initsystem",
      "format": "{name}"
    },\n    {
      "key": "│ {#35}\uf487 pkgs   {#keys} │",
      "type": "packages"
    },
    {
      "key": "├───────────┤",
      "type": "custom"
    },
    {
      "key": "│ {#36}\uf108 desktop{#keys} │",
      "type": "wm"
    },
    {
      "key": "│ {#32}\uf489 shell  {#keys} │",
      "type": "shell"
    },
    {
      "key": "│ {#34}\uf120 term   {#keys} │",
      "type": "terminal"
    },
    {
      "key": "├───────────┤",
      "type": "custom"
    },
    {
      "key": "│ {#33}\uf4bc cpu    {#keys} │",
      "type": "cpu"
    },
    {

      "key": "│ {#31}󰍛 gpu {#keys}    │",
      "type": "gpu",
      "showPeCoreCount": true

    },
    {
      "key": "│ {#36}\uf26c monitor{#keys} │",
      "type": "display"
    },
    {
      "key": "│ {#36} memory {#keys} │",
      "type": "memory"

    },
    {
      "key": "│ {#32}\uf0a0 root   {#keys} │",
      "type": "disk",
      "folders": "/"
    },
    {
      "key": "│ {#33}\uf015 home   {#keys} │",
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

### Passo 3: Criar o Script PowerShell

Crie um arquivo chamado `pokemon.ps1` (ou qualquer nome de sua preferência) em um local de fácil acesso (ex: `C:\Users\SEU_USUARIO\Documents\Scripts\pokemon.ps1`) com o seguinte conteúdo:

**`pokemon.ps1`**
```powershell
# Script PowerShell para gerar Pokémon aleatório para o Fastfetch
# Este script deve ser adicionado ao seu arquivo de perfil do PowerShell ($PROFILE)

# Gera um Pokémon aleatório em ASCII e salva em um arquivo temporário
# O --no-title remove o nome do Pokémon para que apenas a arte ASCII seja exibida
pokemon-colorscripts --random --no-title | Out-File "$env:TEMP\pokemon.txt" -Encoding utf8

# Executa o fastfetch, usando o conteúdo do arquivo temporário como logo
fastfetch --logo-type file-raw --logo "$env:TEMP\pokemon.txt"
```

### Passo 4: Atualizar o Perfil do PowerShell

Para que o script `pokemon.ps1` seja executado toda vez que o PowerShell for iniciado, você precisa adicioná-lo ao seu arquivo de perfil do PowerShell (`$PROFILE`).

1.  Abra o PowerShell 7.
2.  Digite `notepad $PROFILE` e pressione Enter. Isso abrirá o arquivo de perfil no Bloco de Notas. Se o arquivo não existir, o Bloco de Notas perguntará se você deseja criá-lo.
3.  Adicione a seguinte linha ao final do arquivo, substituindo o caminho pelo local onde você salvou `pokemon.ps1`:

    ```powershell
    & "C:\Users\SEU_USUARIO\Documents\Scripts\pokemon.ps1"
    ```

    (Substitua `C:\Users\SEU_USUARIO\Documents\Scripts\pokemon.ps1` pelo caminho real do seu script).
4.  Salve e feche o arquivo.

### Passo 5: Configurar o Alacritty

O Alacritty precisa ser configurado para iniciar o PowerShell 7 e carregar seu perfil. Edite seu arquivo `alacritty.toml` (geralmente localizado em `%APPDATA%\alacritty\alacritty.toml` ou `%USERPROFILE%\.config\alacritty\alacritty.toml`) com o conteúdo fornecido neste projeto.

**`alacritty.toml`**
```toml
# Configuração básica do Alacritty
# Este arquivo pode ser personalizado de acordo com suas preferências.

[shell]
program = "pwsh.exe"
args = ["-NoExit", "-Command", "& {Import-Module Microsoft.PowerShell.Utility; & $PROFILE}"]

[font]
normal = {
    family = "Cascadia Code PL",
    style = "Regular",
}
size = 12

[window]
padding = {
    x = 10,
    y = 10,
}

# Cores (exemplo, pode ser personalizado)
[colors]
primary = {
    background = '0x1e1e1e',
    foreground = '0xd4d4d4',
}
```

## Solução de Problemas

*   **`pip` não reconhecido:** Se o comando `pip` não for encontrado, certifique-se de que o Python está instalado corretamente e que seu diretório de scripts (ex: `C:\Users\SEU_USUARIO\AppData\Local\Programs\Python\Python3x\Scripts`) foi adicionado à variável de ambiente PATH.
*   **Pokémon não aparece:** Verifique os caminhos nos arquivos `config.jsonc` e `pokemon.ps1`. Certifique-se de que o `$PROFILE` do PowerShell está sendo carregado corretamente (você pode adicionar um `Write-Host "Perfil carregado!"` temporariamente no `$PROFILE` para verificar).
*   **Layout incorreto:** Ajuste os valores de `height`, `width` e `padding` na seção `logo` do `config.jsonc` para melhor se adequar ao seu terminal e tamanho de fonte.

## Referências

*   [fastfetch-cli/fastfetch](https://github.com/fastfetch-cli/fastfetch)
*   [pokemon-colorscripts-py](https://pypi.org/project/pokemon-colorscripts-py/)
*   [Alacritty](https://github.com/alacritty/alacritty)
*   [PowerShell](https://github.com/PowerShell/PowerShell)
