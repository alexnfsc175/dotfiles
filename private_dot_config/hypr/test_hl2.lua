local M = {}
function M.test()
    os.execute("echo '" .. type(hl.get_active_window) .. "' > /tmp/hl_test.txt")
end
return M
