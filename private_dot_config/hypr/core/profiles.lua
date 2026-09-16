-- Profiles System
-- Detecta automaticamente o tipo de dispositivo e aplica configurações apropriadas
-- Suporta: laptop, desktop, docked

local config = require("core.config")
local M = {}

-- Detectar tipo de dispositivo de forma instantânea (leitura direta de arquivos, zero IPC, zero jq)
function M.detect_profile()
  -- Verifica se tem bateria (laptop) via leitura direta de sysfs
  local has_battery = false
  for _, b in ipairs({ "BAT0", "BAT1" }) do
    local f = io.open("/sys/class/power_supply/" .. b .. "/status", "r")
    if f then
      local result = f:read("*l")
      f:close()
      if result and #result > 0 then
        has_battery = true
        break
      end
    end
  end

  -- Verifica se tem monitor externo conectado via sysfs (já centralizado em core.config)
  local has_external_monitor = config.is_docked()

  -- Determina o perfil
  if has_battery and has_external_monitor then
    return "docked"
  elseif has_battery then
    return "laptop"
  else
    return "desktop"
  end
end

-- Aplicar configurações baseadas no perfil
function M.apply_profile(profile)
  if profile == "laptop" then
    -- Configurações para laptop
    hl.config({
      misc = {
        vrr = 0,  -- Desabilita VRR para economizar bateria
      },
    })
  elseif profile == "desktop" then
    -- Configurações para desktop
    hl.config({
      misc = {
        vrr = 1,  -- Habilita VRR se disponível
      },
    })
  elseif profile == "docked" then
    -- Configurações para laptop docked
    hl.config({
      misc = {
        vrr = 1,  -- Habilita VRR com monitor externo
      },
    })
  end
end

-- Inicializar perfil
hl.on("hyprland.start", function()
  local profile = M.detect_profile()
  M.apply_profile(profile)
end)

return M
