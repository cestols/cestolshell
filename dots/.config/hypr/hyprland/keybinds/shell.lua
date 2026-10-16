-- hyprland/keybinds/shell.lua: level 2 binds, talk to the shell over IPC (hyprland.qs)

local vars = require("hyprland.variables")
local qs = require("hyprland.qs")

-- ######## Shell ########

hl.bind(vars.mod .. " + CTRL + R", qs.ipc.call("shell", "reload"))
