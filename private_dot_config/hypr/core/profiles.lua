-- Profiles System
-- Detecta automaticamente o tipo de dispositivo e aplica configurações apropriadas
-- Suporta: laptop, desktop, docked

local M = {}

-- Detectar tipo de dispositivo
function M.detect_profile()
  -- Verifica se tem bateria (laptop)
  local has_battery = false
  local handle = io.popen("cat /sys/class/power_supply/BAT0/status 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    has_battery = result and result:len() > 0
  end

  -- Verifica se tem monitor externo conectado
  local has_external_monitor = false
  handle = io.popen("hyprctl monitors -j 2>/dev/null | jq length")
  if handle then
    local result = handle:read("*a")
    handle:close()
    local count = tonumber(result) or 0
    has_external_monitor = count > 1
  end

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
