# 1. Garante que o VS Code encontre os binários do WinGet e os scripts do Program Files
$WinGetPath = "C:\Users\olavo\AppData\Local\Microsoft\WinGet\Packages\Fastfetch-cli.Fastfetch_Microsoft.Winget.Source_8wekyb3d8bbwe"
$PokemonPath = "C:\Program Files\PokemonColorScripts"

if ($env:PATH -notlike "*$WinGetPath*") { $env:PATH += ";$WinGetPath" }
if ($env:PATH -notlike "*$PokemonPath*") { $env:PATH += ";$PokemonPath" }

# --- SEU CÓDIGO ORIGINAL (INTACTO) ---
$themesPath = "C:\Program Files\WindowsApps\ohmyposh.cli_29.16.0.0_x64__96v55e8n804z4\themes"
oh-my-posh init pwsh --config "$themesPath\powerlevel10k_rainbow.omp.json" | Invoke-Expression

$list = (pokemon-colorscripts -List 2>&1) | Where-Object { $_ -match '^\w' } | ForEach-Object { $_.Trim() }
$randomName = $list | Get-Random

$prev = [Console]::OutputEncoding
[Console]::OutputEncoding = [Text.UTF8Encoding]::new($false)
$sprite = pokemon-colorscripts -Name $randomName
[Console]::OutputEncoding = $prev

[System.IO.File]::WriteAllLines("$env:TEMP\pokemon.txt", $sprite, [Text.UTF8Encoding]::new($false))
fastfetch --logo "$env:TEMP\pokemon.txt" --logo-type file-raw --logo-width 22 --logo-height 12