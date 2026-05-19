-- Decoração: borders, gaps, blur, shadow, group
-- Cores vindas de ui/colors.lua

local c = require("ui.colors")

-- Helper para montar rgba com alpha
local function rgba(hex, alpha)
  return "#" .. hex .. alpha
end

hl.config({
  general = {
    border_size        = 2,
    resize_on_border   = true,
    gaps_in            = 2,
    gaps_out           = 5,
    col = {
      inactive_border = rgba(c.lavender, "69"),
      active_border   = { colors = { rgba(c.text, "ee"), rgba(c.lavender, "69"), rgba(c.lavender, "69"), rgba(c.text, "ee") }, angle = 45 },
    },
  },

  decoration = {
    rounding         = 7,
    active_opacity   = 1.0,
    inactive_opacity = 1.0,
    dim_inactive     = false,
    dim_strength     = 0.05,

    blur = {
      enabled          = false,
      size             = 5,
      passes           = 4,
      ignore_opacity   = true,
      new_optimizations = true,
      xray             = false,
      noise            = 0.0,
      popups           = true,
    },

    shadow = {
      enabled      = false,
      range        = 30,
      scale        = 2,
      render_power = 5,
      color        = "rgb(" .. c.crust .. ")",
      color_inactive = "rgb(" .. c.surface0 .. ")",
    },
  },

  group = {
    col = {
      border_inactive        = rgba(c.lavender, "69"),
      border_active          = { colors = { rgba(c.text, "ee"), rgba(c.lavender, "69"), rgba(c.lavender, "69"), rgba(c.text, "ee") }, angle = 45 },
      border_locked_inactive = rgba(c.lavender, "69"),
      border_locked_active   = { colors = { rgba(c.text, "ee"), rgba(c.lavender, "69"), rgba(c.lavender, "69"), rgba(c.text, "ee") }, angle = 45 },
    },

    groupbar = {
      col = {
        active          = rgba(c.lavender, "CC"),
        inactive        = rgba(c.subtext1, "99"),
        locked_active   = rgba(c.maroon, "CC"),
        locked_inactive = rgba(c.subtext1, "99"),
      },
      font_family = "JetBrainsMono Nerd Font",
      font_size   = 10,
      text_color  = "rgb(" .. c.crust .. ")",
      height      = 16,
    },
  },
})
