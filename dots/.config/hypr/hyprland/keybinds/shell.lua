-- hyprland/keybinds/shell.lua: level 2: binds towards the shell via IPC
local vars = require("hyprland.variables")
local qs = require("hyprland.qs")

-- ######## Shell ########

hl.bind(vars.mod .. " + CTRL + R", qs.ipc.call("shell", "reload"))
