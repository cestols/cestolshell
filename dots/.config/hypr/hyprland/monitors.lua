-- hyprland/monitors.lua: monitor configuration (must be loaded first)

-- Fallback for any monitor without an explicit rule
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})
