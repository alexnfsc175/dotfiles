local win = hl.get_active_window()
local f = io.open("/tmp/hl_dump.txt", "w")
if win then
    for k, v in pairs(win) do
        f:write(tostring(k) .. " = " .. type(v) .. " = " .. tostring(v) .. "\n")
    end
else
    f:write("no active window\n")
end
f:close()
