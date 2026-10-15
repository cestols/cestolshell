-- hyprland/variables.lua: default programs

local vars = {
    -- Quickshell config name (folder inside ~/.config/quickshell)
    qs_config = "cestolshell",

    -- Keys
    mod = "SUPER",

    -- Apps
    terminal = "kitty -1",
    launcher = "rofi -show drun", -- fallback launcher, replaced by the shell in 0.6
    file_manager = "dolphin",
    browser = "firefox",
    code_editor = "code",
    volume_mixer = "pavucontrol",
    task_manager = "kitty -1 btop",

    -- Session
    lock = "loginctl lock-session", -- handled by hypridle -> hyprlock
    suspend = "systemctl suspend || loginctl suspend",
    exit = "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'",
}

return vars
