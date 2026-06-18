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