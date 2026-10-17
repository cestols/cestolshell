# Roadmap: versions

Every planned version up to `1.0.0`, with what it implements. Each version is a
testable checkpoint: when its row works in a running session, tag it (`vX.Y.Z`) and
add it to `CHANGELOG.md`. Versioning rules are in [VERSIONING.md](VERSIONING.md), the
reasons behind the stages in [PROJECT.md](PROJECT.md#7-development-roadmap).

This is a plan, not a contract: split, merge or reorder rows when the work shows a
better order, and keep this file in sync when it happens.

Legend: ✅ Done (tagged) · 🟢 Done, not tagged yet · 🔵 Next · ⚪ Planned

## 0.0.x: Standalone Hyprland

| Version | Status | What it implements |
| :--- | :--- | :--- |
| `0.0.0` | ✅ | Hyprland Lua config split in modules (monitors, env, autostart, appearance, M3 animations, input and gestures, window/layer rules), level 1 keybinds, `rofi` as fallback launcher |
| `0.0.1` | ✅ | Test suite (`dev/test.sh`, strict `hl` mock), `hypridle` (dim, lock, screen off, suspend), `hyprlock` with the static M3 palette. **Stage complete** |

## 0.1.x: Simple bar

| Version | Status | What it implements |
| :--- | :--- | :--- |
| `0.1.0` | ✅ | Shell skeleton: Hyprland starts the shell with the session, `IpcHandler` `shell` (`ping`, `reload`), `SUPER + CTRL + R` reloads it through `hyprland.qs` |
| `0.1.1` | ✅ | Empty bar: a `PanelWindow` anchored to the top of every monitor, reserving its space; a named layer rule for it |
| `0.1.2` | 🔵 | Clock in the bar (`SystemClock`); minimal `Appearance` with the bar's height, background, text color and font |
| `0.1.3` | ⚪ | Workspaces in the bar (`Quickshell.Hyprland`): one indicator per workspace, the active one highlighted, click to switch. **Stage complete** |

## 0.2.x: Bar status

| Version | Status | What it implements |
| :--- | :--- | :--- |
| `0.2.0` | ⚪ | Volume indicator (PipeWire): level and mute, scroll on it to change the volume |
| `0.2.1` | ⚪ | Battery indicator (UPower): level and charging state, hidden when there is no battery |
| `0.2.2` | ⚪ | Network indicator: Wi-Fi or Ethernet, signal strength, disconnected state |
| `0.2.3` | ⚪ | System tray (status notifier items), icons from the Material Symbols font. **Stage complete** |

## 0.3.x: Right sidebar

| Version | Status | What it implements |
| :--- | :--- | :--- |
| `0.3.0` | ⚪ | Empty right sidebar that opens and closes: `IpcHandler` + level 2 bind, closes with `Escape` or a click outside |
| `0.3.1` | ⚪ | Quick toggles: Wi-Fi, Bluetooth, do not disturb |
| `0.3.2` | ⚪ | Volume slider (output) and microphone mute. **Stage complete** |

## 0.4.x: Left sidebar (notifications)

| Version | Status | What it implements |
| :--- | :--- | :--- |
| `0.4.0` | ⚪ | Notification server: popups in a screen corner, closed after a timeout or by click |
| `0.4.1` | ⚪ | Left sidebar (IPC + level 2 bind) with the notification history: dismiss one, clear all |
| `0.4.2` | ⚪ | Do not disturb (from `0.3.1`) hides the popups; notification action buttons. **Stage complete** |

## 0.5.x: Refactoring and dynamic colors

| Version | Status | What it implements |
| :--- | :--- | :--- |
| `0.5.0` | ⚪ | `Appearance` becomes M3 tokens (color roles, rounding, spacing, motion), still with a static palette; every module reads them |
| `0.5.1` | ⚪ | Shared widgets extracted from repeated code (button, toggle, slider, card) in `modules/common/widgets/` |
| `0.5.2` | ⚪ | `Config` and `Directories`: user options in a JSON file in `~/.config/cestolshell`, reloaded when edited |
| `0.5.3` | ⚪ | matugen: Material You colors from the wallpaper for the shell |
| `0.5.4` | ⚪ | matugen colors for Hyprland borders and `hyprlock`. **Stage complete** |

## 0.6.x: Launcher

| Version | Status | What it implements |
| :--- | :--- | :--- |
| `0.6.0` | ⚪ | App launcher (IPC + level 2 bind): app list from desktop entries, search, launch on `Enter`; `rofi` stays as the level 1 fallback |
| `0.6.1` | ⚪ | Keyboard navigation, fuzzy search, app icons. **Stage complete** |

## 0.7.x: OSDs and session

| Version | Status | What it implements |
| :--- | :--- | :--- |
| `0.7.0` | ⚪ | Volume and brightness OSDs, shown when the hardware keys change them |
| `0.7.1` | ⚪ | Session screen (IPC + level 2 bind): lock, log out, suspend, reboot, shut down. **Stage complete** |

## 0.8.x: Extras and installer

| Version | Status | What it implements |
| :--- | :--- | :--- |
| `0.8.0` | ⚪ | Level 3 keybinds (`keybinds/extras.lua`): scratchpads, submaps, zoom, utilities |
| `0.8.1` | ⚪ | `setup` installer: `install`, `uninstall`, `checkdeps`. **Stage complete** |

## 1.0.0: Stable

| Version | Status | What it implements |
| :--- | :--- | :--- |
| `1.0.0` | ⚪ | Stabilization: bug fixes and polish after daily use; external contributions open |

Post 1.0 (not planned in detail): `1.x` end-4 parity (settings GUI, workspace overview
with live previews, AI), `2.x` styles engine and desktop widgets.
