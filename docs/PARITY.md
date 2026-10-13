# Upstream Parity Tracking

Tracks feature parity with reference projects.

## end-4 / dots-hyprland (illogical-impulse)

| Feature | Status | Notes |
|---------|--------|-------|
| Hyprland Lua config structure | ✅ Done | Modular, luacheck/stylua clean |
| Tier 1 keybindings | 🟡 Planned | Essential binds work without shell |
| Tier 2 keybindings (IPC) | 🟡 Planned | Requires Quickshell 0.1 |
| Tier 3 keybindings | 🟡 Planned | Workgroups, scratchpads, submaps |
| hyprlock config | 🟡 Planned | In `dots/.config/hypr/hyprlock/` |
| hypridle config | 🟡 Planned | In `dots/.config/hypr/hypridle.conf` |
| Window rules (floating, tiling, PiP) | 🟡 Planned | In `rules.lua` |
| Monitor config | 🟡 Planned | Hardcoded, needs custom override |
| Gestures | 🟡 Planned | 3/4 finger swipe/pinch |
| Animations | 🟡 Planned | Curves + per-element |
| Layer rules | 🟡 Planned | Quickshell/AGS namespaces |
| Autostart (exec-once) | 🟡 Planned | `execs.lua` |
| Custom variables override | 🟡 Partial | `variables.lua` mentions it, missing `pcall(require)` |

## snowarch / iNiR
scm-history-item:/home/cestols/Projects/cestolshell?%7B%22repositoryId%22%3A%22scm1%22%2C%22historyItemId%22%3A%22ab9a8c5a18116249fb38b55a669a35fb9af5007a%22%2C%22historyItemDisplayId%22%3A%22ab9a8c5%22%7D
| Feature | Status | Notes |
|---------|--------|-------|
| Material Design 3 tokens | 🟡 Planned | `Appearance` singleton (0.2) |
| Top bar | 🟡 Planned | 0.3 |
| Right sidebar (control center) | 🟡 Planned | 0.4 |
| Notification daemon | 🟡 Planned | 0.4 |
| Dynamic theming (matugen) | 🟡 Planned | 0.5 |
| Application launcher | 🟡 Planned | 0.6 |
| Workspace overview | 🟡 Planned | 0.6 |
| OSD (volume/brightness) | 🟡 Planned | 0.6 |
| Session/power menu | 🟡 Planned | 0.6 |
| Settings GUI | 🔴 Future | 1.x |
| Left sidebar / AI | 🔴 Future | 1.x |
| Live overview previews | 🔴 Future | 1.x |