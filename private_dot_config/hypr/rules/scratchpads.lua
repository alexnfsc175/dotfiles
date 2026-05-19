-- Scratchpad Rules
-- Regras de janela para os scratchpads do Pyprland

-- Scratchpad grande
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
