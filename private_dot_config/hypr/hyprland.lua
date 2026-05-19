-- ╔══════════════════════════════════════════════╗
-- ║          Hyprland Lua Configuration          ║
-- ║          ~/.config/hypr/hyprland.lua          ║
-- ╚══════════════════════════════════════════════╝
--
-- Requer Hyprland 0.55+
-- Documentação: https://wiki.hypr.land/Configuring/Basics/
--
-- Este arquivo é o entrypoint principal.
-- Cada módulo é auto-contido e chama diretamente as APIs hl.*.
-- A ordem de carregamento importa (env antes de monitors, etc.)

-- ─── Módulos de busca ──────────────────────────────────────
-- Adiciona diretório de config ao package.path para require()
local hypr_dir = os.getenv("HOME") .. "/.config/hypr"
package.path = hypr_dir .. "/?.lua;" .. package.path

-- ─── Core ──────────────────────────────────────────────────
require("core.env")           -- Variáveis de ambiente
require("core.monitors")      -- Layout de monitores
require("core.options")        -- general, misc, dwindle, cursor
require("core.workspaces")     -- Workspace → monitor mapping

-- ─── UI / Aparência ────────────────────────────────────────
require("ui.decoration")      -- Borders, gaps, blur, shadow, group
require("ui.animations")      -- Curvas bezier + animações
require("ui.theme")           -- GTK/Qt dark mode

-- ─── Input ─────────────────────────────────────────────────
require("input.devices")      -- Teclados, mouse, touchpad
require("input.gestures")     -- Gestures de touchpad

-- ─── Keybinds ──────────────────────────────────────────────
require("input.keybinds.apps")        -- Terminal, browser, launcher
require("input.keybinds.windows")     -- Kill, float, resize, swap
require("input.keybinds.workspaces")  -- Switch, move, scroll
require("input.keybinds.media")       -- Volume, brilho, playerctl
require("input.keybinds.actions")     -- Reload, screenshot, wallpaper

-- ─── Rules ─────────────────────────────────────────────────
require("rules.windows")      -- Window rules gerais
require("rules.workspaces")   -- Workspace assignment por app
require("rules.scratchpads")  -- Scratchpad rules
require("rules.layers")       -- Layer rules

-- ─── Autostart (último — tudo já configurado) ──────────────
require("core.autostart")     -- Serviços + dbus
