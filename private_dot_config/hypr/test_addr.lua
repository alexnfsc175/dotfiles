local M = {}
function M.test()
    local win = hl.get_active_window()
    if win then
        os.execute("echo 'type: " .. type(win) .. " tostring: " .. tostring(win) .. " address: " .. tostring(win.address) .. " class: " .. tostring(win.class) .. " pid: " .. tostring(win.pid) .. "' > /tmp/hl_win.txt")
    end
end
return M
