-- Theme Switcher
-- Suporta: light, dark, auto (baseado no horário)

local M = {}

-- Temas disponíveis
M.themes = {
  dark = {
    name = "Catppuccin Macchiato",
    gtk_theme = "Catppuccin-Macchiato",
    icon_theme = "Tela-dracula-dark",
    color_scheme = "prefer-dark",
  },
  light = {
    name = "Catppuccin Latte",
    gtk_theme = "Catppuccin-Latte",
    icon_theme = "Tela-dracula-light",
    color_scheme = "prefer-light",
  },
}

-- Detectar tema automaticamente baseado no horário
function M.detect_auto_theme()
  local hour = tonumber(os.date("%H"))
  -- Dark mode das 18:00 às 06:00
  if hour >= 18 or hour < 6 then
    return "dark"
  else
    return "light"
  end
end

-- Aplicar tema
function M.apply_theme(theme_name)
  local theme = M.themes[theme_name]
  if not theme then return end

  -- Aplicar via gsettings
  hl.exec_cmd("uwsm app -- sh -c 'gsettings set org.gnome.desktop.interface gtk-theme " .. theme.gtk_theme .. "'")
  hl.exec_cmd("uwsm app -- sh -c 'gsettings set org.gnome.desktop.interface icon-theme " .. theme.icon_theme .. "'")
  hl.exec_cmd("uwsm app -- sh -c 'gsettings set org.gnome.desktop.interface color-scheme " .. theme.color_scheme .. "'")
end

-- Alternar entre temas
function M.toggle_theme()
  local current = M.current_theme or "dark"
  local new_theme = current == "dark" and "light" or "dark"
  M.current_theme = new_theme
  M.apply_theme(new_theme)
end

-- Inicializar tema
function M.init(mode)
  mode = mode or "dark"
  if mode == "auto" then
    M.current_theme = M.detect_auto_theme()
  else
    M.current_theme = mode
  end
  M.apply_theme(M.current_theme)
end

-- Keybind para alternar tema
hl.bind("SUPER + CTRL + T", function()
  M.toggle_theme()
end, {
  description = "Alternar tema (light/dark)",
})

return M
