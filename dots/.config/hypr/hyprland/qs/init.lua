-- hyprland/qs/init.lua: shell integration: loads and exposes the qs submodules (ipc, ...)

-- Shell IPCs
return {
    ipc = require("hyprland.qs.ipc"),
}
