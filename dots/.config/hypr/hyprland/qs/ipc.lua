-- hyprland/qs/ipc.lua: IPC helper towards Quickshell.
-- All binds towards the shell go through here (qs ipc call), never global shortcuts.
local vars = require("hyprland.variables")

local M = {}

-- exec_cmd runs the line through `sh -c`: wrap each value in single quotes so spaces
-- and quotes stay one argument. Inside single quotes nothing can be escaped, so an
-- embedded ' becomes '\'' (close the quote, escaped quote, reopen).
local function quote(value)
    value = tostring(value)

    value = "'" .. (value:gsub("'", "'\\''")) .. "'"

    return value
end

-- Returns the command line `qs -c '<config>' ipc call '<target>' '<fn>' ['<arg>'...]`.
-- Extra arguments are converted with tostring and quoted like the rest.
function M.command(target, fn, ...)
    -- table.pack keeps the count in args.n, even when some arguments are nil
    local args = table.pack(...)

    for i = 1, args.n do
        args[i] = quote(args[i])
    end

    local cmd = { "qs -c", quote(vars.qs_config), "ipc call", quote(target), quote(fn), table.unpack(args, 1, args.n) }

    return table.concat(cmd, " ")
end

-- Returns a dispatcher running `qs -c <config> ipc call <target> <fn> [args...]`.
function M.call(target, fn, ...)
    return hl.dsp.exec_cmd(M.command(target, fn, ...))
end

return M
