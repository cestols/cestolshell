# cestolshell

A custom, modern desktop environment built for **Hyprland** using **Quickshell** (QML/Qt6), designed with Google's **Material Design 3 (Material You)** aesthetics.

![License: GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-blue.svg)
![Hyprland: 0.56.2](https://img.shields.io/badge/Hyprland-0.56.2-heroic.svg)
![Quickshell: Qt6](https://img.shields.io/badge/Shell-Quickshell--Qt6-green.svg)

> [!WARNING]
> **Early development (stage 0.1).** Only the standalone Hyprland config (Lua, plus
> `hyprlock`/`hypridle`, released in `v0.0`) exists so far. The Quickshell shell is next.
> Not usable as a daily driver.

---

## 🌟 Overview

**cestolshell** is a from-scratch dotfiles configuration and desktop shell tailored for Arch Linux and derivatives. Instead of relying on traditional GTK/Qt status bars or monolithic shells, it integrates a lightweight, fully modular QML shell written for [Quickshell](https://quickshell.outfoxxed.me/), featuring dynamic Material You theming and IPC integration with Hyprland.

### Core Inspirations

- **[end-4 / dots-hyprland (illogical-impulse)](https://github.com/end-4/dots-hyprland):** Functional skeleton, Hyprland compositor interaction, keybindings, and module structure.
- **[snowarch / iNiR](https://github.com/snowarch/iNiR):** Visual identity based on the *Material ii* style, design tokens, sidebar concepts, and widget design.

---

## 🛠️ Stack & Technologies

* **Window Manager / Compositor:** [Hyprland](https://hyprland.org/) (tested with `v0.56.2`), configured natively in **Lua**.
* **Desktop Shell:** [Quickshell](https://quickshell.outfoxxed.me/) (Qt 6 & QML).
* **Color Palette / Dynamic Theming:** `matugen` (generates M3 color roles from the wallpaper as JSON tokens).
* **System Services:** PipeWire / WirePlumber (Audio), NetworkManager (Network), BlueZ (Bluetooth), UPower (Battery), `brightnessctl`, `playerctl`.
* **Dotfiles Management:** [GNU Stow](https://www.gnu.org/software/stow/).
* **Target OS:** Arch Linux / CachyOS and derivatives.

---

## 🚀 Key Features

Available now:

* 🛠️ **Lua Hyprland Config:** Modular configuration using Hyprland's native Lua interface (monitors, env, autostart, appearance, M3 motion curves, input and gestures, window/layer rules, level 1 keybindings).
* ✅ **Tested Config:** `dev/test.sh` runs `Hyprland --verify-config` plus Lua checks against a strict mock of the `hl` API built from Hyprland's own stubs.

Planned (see the roadmap):

* 🎨 **Material Design 3 System:** Single source of truth for colors, corner radii, elevation, spacing, and motion curves via a centralized `Appearance` singleton.
* ⚡ **Decoupled Architecture:** IPC-first communication between Hyprland and Quickshell (`qs -c cestolshell ipc call`).
* 🔒 **Layered Keybindings:** 3-level keybinding structure ensuring the system remains controllable even if the shell reloads or crashes.
* 🧩 **Modular Shell Layout:** Lazy-loaded panels (Launcher, Sidebar, OSD, Notifications, Overview) to maintain low resource usage.

---

## 📂 Repository Structure

Entries marked *(planned)* are created when their roadmap stage starts.

```text
cestolshell/
├── dots/                                # $HOME mirror, installed with GNU Stow
│   └── .config/
│       ├── hypr/
│       │   ├── hyprland.lua             # Entry point: loads hyprland/* in order
│       │   ├── hyprland/                # Hyprland modules (monitors, env, execs, rules, keybinds, ...)
│       │   │   ├── keybinds/            # essential.lua (level 1); shell.lua (0.1+), extras.lua (planned, 0.7)
│       │   │   ├── lib/                 # Lua helper functions
│       │   │   └── qs/                  # Shell integration: init.lua + ipc.lua helper (0.1)
│       │   ├── hypridle.conf            # Idle timeouts: dim, lock, screen off, suspend
│       │   ├── hyprlock.conf            # Lock screen
│       │   └── scripts/                 # Hyprland helper scripts
│       ├── matugen/                     # Palette config and templates (planned, 0.5)
│       └── quickshell/cestolshell/      # Quickshell package root (planned, 0.1+)
├── dev/                                 # Development helpers (scaffold, tests, nested Hyprland)
├── docs/                                # Project, versioning, notice and parity docs
├── sdata/dist-arch/                     # Package lists: core, system, theming, aur, dev
├── tests/hypr/                          # Lua checks for the Hyprland config
├── assets/                              # Default wallpapers and fonts (planned, 0.2)
├── setup                                # Installer: install, uninstall, checkdeps (planned, 0.7)
├── CHANGELOG.md
└── README.md
```

---

## 📦 Installation (manual)

The `setup` installer arrives in stage 0.7. Until then:

```bash
dev/checkdeps.sh core system theming aur   # list missing packages
stow -d . -t ~ --no-folding dots           # link dots/ into $HOME (defaults also in .stowrc)
```

Try the config in a nested session first (see below).

---

## 🧪 Development

```bash
dev/run-nested.sh            # nested Hyprland in a sandboxed XDG env linked to dots/.config
dev/test.sh                  # Hyprland --verify-config + Lua checks in tests/hypr
pre-commit run --all-files   # stylua, luacheck, shellcheck, qmllint, dev/test.sh
dev/scaffold.sh --stage 0.1  # create the structure of a stage (never overwrites files)
```

Development packages are listed in `sdata/dist-arch/dev.txt`. Conventions are described in [CONTRIBUTING.md](CONTRIBUTING.md).

---

## ⌨️ Keybindings Philosophy

Keybindings in `cestolshell` are split into three levels:

1. **Level 1 (Essential):** System-critical binds mapped directly in Hyprland (terminal, fallback launcher, window management, workspaces, audio/brightness keys, session exit). Works independently of the shell.
2. **Level 2 (Shell Integration):** Binds that trigger Quickshell modules over IPC (launcher, overview, sidebars, OSDs), added together with each shell feature. Never global shortcuts.
3. **Level 3 (Comfort & Extra):** Advanced workspace controls, scratchpads, submaps, screen zoom, and utility modes.

### Level 1 binds

Defined in `dots/.config/hypr/hyprland/keybinds/essential.lua`; programs come from `variables.lua`.

| Keys | Action |
| :--- | :--- |
| `SUPER + Return` | Terminal (`kitty`) |
| `SUPER + R` | Fallback launcher (`rofi`) |
| `SUPER + E` / `W` / `C` | File manager / browser / code editor |
| `SUPER + CTRL + V` | Volume mixer (`pavucontrol`) |
| `CTRL + SHIFT + Escape` | Task manager (`btop`) |
| `SUPER + Q` | Close window |
| `SUPER + SHIFT + ALT + Q` | Kill window |
| `SUPER + F` / `M` | Fullscreen / maximize |
| `SUPER + ALT + Space` | Toggle floating |
| `SUPER + P` | Pin window |
| `SUPER + J` | Toggle split (dwindle) |
| `SUPER + Arrows` | Move focus |
| `SUPER + SHIFT + Arrows` | Move window |
| `SUPER + LMB` / `RMB` drag | Move / resize window |
| `SUPER + 1..0` | Go to workspace 1-10 |
| `SUPER + SHIFT + 1..0` | Move window to workspace 1-10 |
| `SUPER + Scroll` | Previous / next workspace |
| `SUPER + L` | Lock (`loginctl lock-session` -> `hypridle` -> `hyprlock`) |
| `SUPER + SHIFT + L` | Suspend |
| `CTRL + ALT + Delete` | Exit Hyprland |
| Volume, brightness, media keys | `wpctl`, `brightnessctl`, `playerctl` (also on the lock screen) |

---

## 🗺️ Development Roadmap

Full details in [docs/PROJECT.md](docs/PROJECT.md#7-development-roadmap).

- [x] **0.0 - Standalone Hyprland:** Lua configuration, level 1 keybinds, `hyprlock`, and fallback launcher. *(released in `v0.0`: config modules and level 1 keybinds in `v0.0.0`, `hyprlock` and `hypridle` in `v0.0.1`)*
- [ ] **0.1 - Quickshell Core:** `shell.qml`, `Config`, `Appearance`, Hyprland service, and basic IPC.
- [ ] **0.2 - Design System:** M3 design tokens and primitive widgets (Button, Toggle, Slider, Card).
- [ ] **0.3 - Bar & Services:** System services and a functional top bar.
- [ ] **0.4 - Notifications & Control Center:** Notification server and right sidebar.
- [ ] **0.5 - Dynamic Theming:** Material You colors generated from the wallpaper via `matugen`.
- [ ] **0.6 - Launcher & Session:** App launcher, overview, OSDs, and session screen.
- [ ] **0.7 - Extras & Installer:** Level 3 keybinds and the `setup` CLI installer.
- [ ] **1.0 - Stable:** Stabilization and daily-driver validation.

---

## 🤝 Contributing

External contributions open after `1.0.0`. See [CONTRIBUTING.md](CONTRIBUTING.md).

---

## 📄 License

Distributed under the **GNU General Public License v3.0** (`GPL-3.0`). See [`LICENSE`](LICENSE) for details.

*Note: Code adapted from `end-4/dots-hyprland` or `snowarch/iNiR` keeps its original copyright headers, and is credited in [`docs/NOTICE.md`](docs/NOTICE.md).*
