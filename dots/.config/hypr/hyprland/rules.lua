-- hyprland/rules.lua: window, workspace, and layer rules

-- ######## Window rules ########

-- Ignore app maximize requests so restored window states do not override tiling
hl.window_rule({ name = "suppress-maximize", match = { class = ".*" }, suppress_event = "maximize" })

-- Fix dragging issues with XWayland
hl.window_rule({
    name = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

-- Blur only layers (shell panels), never windows
hl.window_rule({ name = "no-blur", match = { class = ".*" }, no_blur = true })

-- No shadow for tiled windows
hl.window_rule({ name = "no-shadow-tiled", match = { float = false }, no_shadow = true })

-- Highlight pinned windows
hl.window_rule({ name = "pinned-border", match = { pin = true }, border_color = "rgba(afc6ffaa) rgba(afc6ff77)" })

-- Floating dialogs
local dialog_titles = {
    "^(Open File)(.*)$",
    "^(Select a File)(.*)$",
    "^(Open Folder)(.*)$",
    "^(Save As)(.*)$",
    "^(Library)(.*)$",
    "^(File Upload)(.*)$",
    "^(.*)(wants to save)$",
    "^(.*)(wants to open)$",
}
for i, title in ipairs(dialog_titles) do
    hl.window_rule({ name = "float-dialog-" .. i, match = { title = title }, float = true, center = true })
end

-- Floating utilities
local utility_classes = {
    "^(pavucontrol)$",
    "^(org.pulseaudio.pavucontrol)$",
    "^(nm-connection-editor)$",
    "^(blueberry\\.py)$",
    "^(hyprland-run)$",
}
for i, class in ipairs(utility_classes) do
    hl.window_rule({
        name = "float-utility-" .. i,
        match = { class = class },
        float = true,
        center = true,
        size = "monitor_w*0.45 monitor_h*0.45",
    })
end
hl.window_rule({ name = "float-kcm", match = { class = "kcm_.*" }, float = true })
hl.window_rule({ name = "float-plasmawindowed", match = { class = ".*plasmawindowed.*" }, float = true })
hl.window_rule({ name = "float-polkit", match = { class = "^(hyprpolkitagent)$" }, float = true, center = true })

-- Picture-in-Picture
hl.window_rule({
    name = "pip",
    match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" },
    float = true,
    pin = true,
    keep_aspect_ratio = true,
    size = "monitor_w*0.25 monitor_h*0.25",
    move = "monitor_w*0.73 monitor_h*0.72",
})

-- Screen sharing indicator
hl.window_rule({
    name = "screenshare-indicator",
    match = { title = ".*is sharing (a window|your screen).*" },
    float = true,
    pin = true,
    move = "monitor_w*0.5-window_w*0.5 monitor_h-window_h-12",
})

-- Tearing for games
hl.window_rule({ name = "tearing-exe", match = { title = ".*\\.exe" }, immediate = true })
hl.window_rule({ name = "tearing-steam", match = { class = "^(steam_app).*" }, immediate = true })
hl.window_rule({ name = "tearing-minecraft", match = { title = ".*minecraft.*" }, immediate = true })

-- ######## Workspace rules ########

-- More room around the special workspace
hl.workspace_rule({ workspace = "special:magic", gaps_out = 30 })

-- ######## Layer rules ########

-- Layer blur shows the wallpaper, not the windows below
hl.layer_rule({ name = "xray-layers", match = { namespace = ".*" }, xray = true })

-- Fallback launcher: fast and blurred
hl.layer_rule({
    name = "launcher-rofi",
    match = { namespace = "^rofi$" },
    no_anim = true,
    blur = true,
    ignore_alpha = 0.5,
})
hl.layer_rule({ name = "launcher-gtk4", match = { namespace = "^gtk4-layer-shell$" }, no_anim = true })

-- Tools that must appear instantly
hl.layer_rule({ name = "no-anim-selection", match = { namespace = "^(selection|hyprpicker)$" }, no_anim = true })

-- Quickshell layer rules
hl.layer_rule({
    name = "bar",
    match = { namespace = "quickshell:bar" },
    blur = true,
    ignore_alpha = 0.2,
})
