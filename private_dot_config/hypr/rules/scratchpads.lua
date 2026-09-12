-- Scratchpad Rules (Nativo)
-- Substitui Pyprland com special workspaces nativos do Hyprland
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/#special-workspace

-- Função para criar scratchpad toggle
local function toggle_scratchpad(name, cmd)
  return function()
    local ws = "special:" .. name
    local windows = hl.get_workspace_windows(ws)
    if windows and #windows > 0 then
      -- Se já tem janelas, toggle para esconder
      hl.dispatch("togglespecialworkspace " .. name)
    else
      -- Se não tem janelas, abre o app e move para special workspace
      hl.exec_cmd(cmd)
      -- Espera um pouco para o app abrir, então move para special workspace
      hl.dispatch("[class=\".*\"] movetoworkspace special:" .. name)
    end
  end
end

-- Scratchpad grande (terminal, yazi, etc)
hl.window_rule({
  match     = { class = "^(scratchpad-large)$" },
  float     = true,
  center    = true,
  size      = "(monitor_w*0.7) (monitor_h*0.7)",
  animation = "slide",
  workspace = "special:scratchpad-large silent",
})

-- Scratchpad normal
hl.window_rule({
  match     = { class = "^(scratchpad)$" },
  float     = true,
  center    = true,
  size      = "(monitor_w*0.5) (monitor_h*0.5)",
  animation = "slide",
  workspace = "special:scratchpad silent",
})

-- Scratchpad mini
hl.window_rule({
  match     = { class = "^(scratchpad-mini)$" },
  float     = true,
  center    = true,
  size      = "(monitor_w*0.3) (monitor_h*0.4)",
  animation = "slide",
  workspace = "special:scratchpad-mini silent",
})

-- Side scratchpad (volume/bluetooth)
hl.window_rule({
  match     = { class = "^(.*pavucontrol.*)$|(.*blueman-manager.*)$" },
  float     = true,
  center    = true,
  size      = "30% 90%",
  workspace = "special:scratchpad silent",
})

-- Keybinds para scratchpads
hl.bind("SUPER + F1", toggle_scratchpad("scratchpad-large", "kitty --class scratchpad-large"), {
  description = "Toggle terminal scratchpad",
})

hl.bind("SUPER + F2", toggle_scratchpad("scratchpad", "kitty --class scratchpad"), {
  description = "Toggle scratchpad",
})

hl.bind("SUPER + F3", toggle_scratchpad("scratchpad-mini", "kitty --class scratchpad-mini"), {
  description = "Toggle mini scratchpad",
})

-- Toggle special workspace genérico
hl.bind("SUPER + grave", function()
  hl.dispatch("togglespecialworkspace scratchpad")
end, {
  description = "Toggle scratchpad workspace",
})
