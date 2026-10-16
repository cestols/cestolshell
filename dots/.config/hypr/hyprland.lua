-- hyprland.lua: entry point, requires the hyprland.* modules in load order

-- Base config (monitors must be first)
require("hyprland.monitors")
require("hyprland.env")
require("hyprland.execs")
require("hyprland.appearance")
require("hyprland.animations")
require("hyprland.input")
require("hyprland.rules")

-- Keybinds
require("hyprland.keybinds.essential")
require("hyprland.keybinds.shell")
-- TODO(0.8): level 3 binds
-- require("hyprland.keybinds.extras")

-- Custom modules
-- TODO: support custom configs
