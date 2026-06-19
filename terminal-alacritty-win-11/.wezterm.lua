local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- --- ESTILIZAÇÃO E PERFORMANCE ---
config.font = wezterm.font('JetBrainsMono NF')
config.font_size = 11.0
config.harfbuzz_features = { 'liga=1', 'calt=1' } 

-- VOLTAR A BARRA DE FECHAR: Mudei de "RESIZE" para "TITLE | RESIZE"
config.window_decorations = "TITLE | RESIZE"

-- --- IMAGEM DE FUNDO ---
config.window_background_image = "C:\\\\Users\\\\olavo\\\\Pictures\\\\Wallpaper\\\\wallpaper-static\\\\image.jpeg"

config.window_background_image_hsb = {
  brightness = 0.15,
  saturation = 0.8,
}

-- --- PROFILE AUTOMÁTICO DO POWERSHELL CORRIGIDO ---
-- Removemos o Set-Location fixo. Agora ele mantém a pasta onde você clicou 
-- e roda o script do pokemon logo em seguida.
config.default_prog = { 
  'pwsh.exe', 
  '-NoLogo', 
  '-NoExit', 
  '-Command', 
  '& C:\\Users\\olavo\\AppData\\Roaming\\fastfetch\\pokemon.ps1' 
}

return config
