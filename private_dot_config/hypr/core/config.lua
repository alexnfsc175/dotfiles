-- Configuração compartilhada de monitores
-- Edite ws_per_monitor para mudar a quantidade de workspaces por monitor

local hyprland = require("lib.hyprland")

-- Função para detectar monitores dinamicamente (chamar depois do startup)
local function get_monitors()
	local monitors = hyprland.get_monitors()

	local monitor_names = {}
	for _, monitor in ipairs(monitors) do
		table.insert(monitor_names, monitor.name)
	end

	return #monitor_names > 0 and monitor_names or { "eDP-1" }
end

-- -- Função para detectar monitores dinamicamente (chamar depois do startup)
-- local function get_monitors()
--   local handle = io.popen("hyprctl -j monitors 2>/dev/null | jq -r 'sort_by(.id) | .[] | (.id|tostring) + \" \" + .name'")
--   if not handle then return { "E-DP-1" } end

--   local result = handle:read("*a")
--   handle:close()

--   local monitors = {}
--   for line in result:gmatch("[^\n]+") do
--     local name = line:match("^%d+ (.+)$")
--     if name then
--       table.insert(monitors, name)
--     end
--   end

--   return #monitors > 0 and monitors or { "E-DP-1" }
-- end

return {
	monitors = { "eDP-1", "DP-2", "HDMI-A-1" },
	-- monitors = get_monitors(),
	ws_per_monitor = 3,
	get_monitors = get_monitors,
}
