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

# --- NOVO MOTOR: POKÉMON EM ALTA DEFINIÇÃO (PNG REALS) ---
# Sorteia o ID de um Pokémon (Ex: 1 a 1010)
$pokemonID = Get-Random -Minimum 1 -Maximum 898

# URL da API oficial que contém os artworks oficiais em alta definição e com fundo transparente
$imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonID.png"
$localPngPath = "$env:TEMP\pokemon_hd.png"

# Faz o download silencioso da imagem limpa em PNG
Invoke-WebRequest -Uri $imageUrl -OutFile $localPngPath -ErrorAction SilentlyContinue

# Executa o Fastfetch forçando o WezTerm a renderizar o PNG usando o protocolo 'iterm'
fastfetch --config "$env:APPDATA\fastfetch\config.json"