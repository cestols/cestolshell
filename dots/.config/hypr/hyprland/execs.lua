-- hyprland/execs.lua: programs to start with the session

hl.on("hyprland.start", function()
    -- Make the session environment visible to systemd/D-Bus activated services (portals, polkit)
    hl.exec_cmd(
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE"
    )

    -- Core components
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("hypridle")

    -- Cursor (also applies to apps that ignore XCURSOR_THEME)
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 24")

    -- 0.1: hl.exec_cmd("qs -c " .. require("hyprland.variables").qs_config)
end)
