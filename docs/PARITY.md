# Upstream Parity Tracking

Tracks feature parity with reference projects. Versions point to the rows of
[ROADMAP.md](ROADMAP.md).

Legend: ✅ Done · 🟠 Partial · 🟡 Planned · 🔴 Future (post 1.0)

## end-4 / dots-hyprland (illogical-impulse)

| Feature | Status | Notes |
|---------|--------|-------|
| Hyprland Lua config structure | ✅ Done | Modular, luacheck/stylua clean, covered by `dev/test.sh` |
| Monitor config | ✅ Done | Fallback rule only (`preferred`, `auto`); per-machine overrides come with custom configs |
| Environment variables | ✅ Done | `env.lua`: cursor, Wayland-first toolkits, Flatpak data dirs |
| Autostart (exec-once) | ✅ Done | `execs.lua` (`hyprland.start` hook): D-Bus env, polkit agent, hypridle, cursor, shell |
| Animations | ✅ Done | M3 motion curves + per-element animations in `animations.lua` |
| Gestures | ✅ Done | 3-finger move/pinch fullscreen, 4-finger workspace swipe; overview gesture in 1.x |
| Window rules (floating, tiling, PiP) | ✅ Done | `rules.lua`: dialogs, utilities, PiP, screen share indicator, tearing |
| Layer rules | 🟠 Partial | Fallback launcher and tools done; `quickshell:*` namespaces from 0.1.1 (bar) |
| Tier 1 keybindings | ✅ Done | `keybinds/essential.lua`: apps, windows, workspaces 1-10, session, hardware keys |
| Fallback launcher | ✅ Done | `rofi` on `SUPER + R`, layer rules in `rules.lua`; replaced by the shell in 0.6 |
| hyprlock config | ✅ Done | `hyprlock.conf`: blurred snapshot, clock, date, password field; static M3 palette, matugen colors in 0.5 |
| hypridle config | ✅ Done | `hypridle.conf`: dim, lock, DPMS off, suspend; lock before sleep |
| Custom config override | 🟡 Planned | `TODO` in `hyprland.lua` (user overrides loaded with `pcall(require)`) |
| Tier 2 keybindings (IPC) | 🟠 Partial | `keybinds/shell.lua` through `hyprland.qs`: shell reload (0.1.0); one bind per shell feature from 0.3 |
| Tier 3 keybindings | 🟡 Planned | 0.8.0: workspaces, scratchpads, submaps, zoom |
| Installer (`setup`) | 🟡 Planned | 0.8.1; `dev/checkdeps.sh` covers dependency checks meanwhile |
| Settings GUI | 🔴 Future | 1.x |
| Left sidebar (notifications) | 🟡 Planned | 0.4.x |
| AI | 🔴 Future | 1.x |
| Live overview previews | 🔴 Future | 1.x |

## snowarch / iNiR

| Feature | Status | Notes |
|---------|--------|-------|
| Shell directory architecture | 🟠 Partial | `modules/common/` from 0.1, `services/` from 0.2, shared widgets in 0.5.1 |
| Material Design 3 tokens | 🟡 Planned | Minimal `Appearance` in 0.1.2, M3 tokens in 0.5.0 |
| Top bar | 🟡 Planned | 0.1.x (clock, workspaces), 0.2.x (volume, battery, network, tray) |
| Right sidebar (control center) | 🟡 Planned | 0.3.x |
| Notification daemon | 🟡 Planned | 0.4.x |
| Dynamic theming (matugen) | 🟡 Planned | 0.5.3 (shell), 0.5.4 (Hyprland, hyprlock); static M3 colors until then |
| Application launcher | 🟡 Planned | 0.6.x |
| Workspace overview | 🔴 Future | 1.x (with live previews) |
| OSD (volume/brightness) | 🟡 Planned | 0.7.0 |
| Session/power menu | 🟡 Planned | 0.7.1 |
| Desktop widgets | 🔴 Future | 2.x |
