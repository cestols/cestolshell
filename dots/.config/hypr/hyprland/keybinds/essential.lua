-- hyprland/keybinds/essential.lua: level 1: binds that only talk to Hyprland and system programs, never to the shell

local vars = require("hyprland.variables")

-- ######## Apps ########

hl.bind(vars.mod .. " + Return", hl.dsp.exec_cmd(vars.terminal))
hl.bind(vars.mod .. " + R", hl.dsp.exec_cmd(vars.launcher)) -- 0.6: replaced by the shell launcher
hl.bind(vars.mod .. " + E", hl.dsp.exec_cmd(vars.file_manager))
hl.bind(vars.mod .. " + W", hl.dsp.exec_cmd(vars.browser))
hl.bind(vars.mod .. " + C", hl.dsp.exec_cmd(vars.code_editor))
hl.bind(vars.mod .. " + CTRL + V", hl.dsp.exec_cmd(vars.volume_mixer))
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd(vars.task_manager))

-- ######## Windows ########

hl.bind(vars.mod .. " + Q", hl.dsp.window.close())
hl.bind(vars.mod .. " + SHIFT + ALT + Q", hl.dsp.window.kill())

hl.bind(vars.mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(vars.mod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(vars.mod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(vars.mod .. " + P", hl.dsp.window.pin())
hl.bind(vars.mod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

-- Focus and move with the arrows
local directions = { Left = "left", Right = "right", Up = "up", Down = "down" }
for key, direction in pairs(directions) do
    hl.bind(vars.mod .. " + " .. key, hl.dsp.focus({ direction = direction }))
    hl.bind(vars.mod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
end

-- Mouse: drag to move, right drag to resize
hl.bind(vars.mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(vars.mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ######## Workspaces ########

for i = 1, 10 do
    local key = tostring(i % 10) -- 0 is workspace 10
    hl.bind(vars.mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(vars.mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(vars.mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(vars.mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- ######## Session ########

hl.bind(vars.mod .. " + L", hl.dsp.exec_cmd(vars.lock))
hl.bind(vars.mod .. " + SHIFT + L", hl.dsp.exec_cmd(vars.suspend))
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd(vars.exit))

-- ######## Hardware keys ########

-- Work on the lock screen too; volume and brightness repeat while held
local held = { locked = true, repeating = true }
local locked = { locked = true }

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), held)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), held)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), locked)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), locked)

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), held)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), held)

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), locked)
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), locked)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), locked)
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), locked)
