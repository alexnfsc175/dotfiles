-- Opções gerais do compositor
-- Consolida: general, misc, xwayland, dwindle, cursor

hl.config({
  general = {
    layout        = "dwindle",
    allow_tearing = true,
  },

  misc = {
    always_follow_on_dnd         = true,
    disable_hyprland_logo        = true,
    vrr                          = 0,
    animate_manual_resizes       = true,
    animate_mouse_windowdragging = false,
    enable_swallow               = true,
    font_family                  = "JetBrainsMono Nerd Font",
    swallow_regex                = "^(Alacritty|kitty|footclient|foot|com.mitchellh.ghostty)$",
  },

  xwayland = {
    force_zero_scaling = true,
  },

  dwindle = {

    preserve_split = true,
    force_split   = 0,
  },

  cursor = {
    no_hardware_cursors = true,
  },

  debug = {
    disable_logs = false,
  },
})
