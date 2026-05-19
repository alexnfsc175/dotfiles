local M = {}

-- Tabela em memória para persistir a opacidade por janela (address)
local window_states = {}

function M.change(direction)
    local step = 0.02
    local min  = 0.4
    local max  = 1.0

    -- 1. Obtém informações da janela ativa nativamente
    local win = hl.get_active_window()
    if not win then return end

    -- Usa a propriedade address ou o identificador do objeto para a tabela
    local address = tostring(win.address or win)

    -- 2. Calcula nova opacidade
    local last_val = window_states[address] or 1.0
    local new_val  = last_val

    if direction == "+" then
        new_val = math.min(max, last_val + step)
    else
        new_val = math.max(min, last_val - step)
    end

    -- 3. Salva o novo estado na memória
    window_states[address] = new_val

    -- 4. Aplica ao Hyprland usando o dispatcher correto em Lua sem travar
    hl.dispatch(hl.dsp.window.set_prop({
        prop = "opacity",
        value = tostring(new_val)
    }))
end

return M
