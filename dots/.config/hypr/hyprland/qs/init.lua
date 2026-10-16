-- hyprland/qs/init.lua: shell integration, loads and exposes the qs submodules (ipc, ...)

return {
    ipc = require("hyprland.qs.ipc"), -- qs ipc call dispatchers
}
