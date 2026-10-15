# Project Architecture & Roadmap

This document outlines the decisions, motivations, tech stack, architecture, and roadmap for `cestolshell`.

---

## 1. Goal

Build a modular, long-term dotfiles ecosystem for Hyprland featuring a custom QML desktop shell built on **Quickshell**. The design is inspired by two reference projects:

- **end-4 / dots-hyprland** (`illogical-impulse`, "ii"): Functional skeleton for Hyprland integration, module structures, and workflow routines.
- **snowarch / iNiR**: Visual inspiration for the Material design language (design tokens, panels, widgets).

Instead of fork-and-modify, the codebase is being rewritten from scratch to ensure a clean architecture, deep code ownership, and ease of long-term maintenance.

---

## 2. References & Attribution

| Project                   | Role                | Usage                                                                         |
| :------------------------ | :------------------ | :---------------------------------------------------------------------------- |
| **end-4 / dots-hyprland** | Functional baseline | Keybindings, compositor integration, module layout, MVP feature set. |
| **snowarch / iNiR**       | Aesthetic baseline  | Material ii aesthetic tokens, bar, right sidebar, desktop widgets.   |

> **Note:** Both upstream projects are licensed under GPL-3.0. Re-implementing concepts and adapting existing snippets is done in full compliance with GPL-3.0. Upstream copyright headers are preserved, and credit is tracked in `docs/NOTICE.md`.

---

## 3. Technical Decisions

- **Repository Layout**: Inspired by `end-4`. A `dots/` directory mirrors `$HOME` and is installed via GNU Stow (`stow -d . -t ~ --no-folding dots`).
- **Shell Architecture**: Inspired by `iNiR`. Separated into `modules/common/` (appearance, tokens, shared widgets) and `services/`.
- **Window Manager**: Hyprland (tested with v0.56.2), configured using native **Lua** scripts (`hyprland.lua`).
- **IPC First**: The compositor communicates with Quickshell strictly via IPC commands (`qs -c cestolshell ipc call <target> <function>`, wrapped by the `hyprland.qs` Lua module: `qs/init.lua` exposes `ipc.lua` and future helpers) without relying on global shortcuts.
- **Testing**: `dev/test.sh` runs `Hyprland --verify-config`, then Lua checks against a strict mock of the `hl` API generated from Hyprland's stubs (`/usr/share/hypr/stubs/hl.meta.lua`), so calls to functions the installed Hyprland does not provide fail.
- **Theme Generation**: **Matugen** generates M3 color roles in a JSON payload, consumed by the shell's `Appearance` singleton.

---

## 4. Stack & Tooling

- **Shell**: Quickshell (Qt 6 / QML + JavaScript).
- **Compositor**: Hyprland (Lua configuration format).
- **OS Services**: PipeWire, WirePlumber, NetworkManager, BlueZ, UPower, `brightnessctl`, `playerctl`.
- **Dotfiles Management**: GNU Stow, Git.
- **Quality Assurance**:
  - QML: `qmllint`, `qmlformat`
  - Lua: `lua-language-server`, `stylua`, `luacheck`
  - Bash: `shellcheck`
  - Hyprland config: `dev/test.sh` (`--verify-config` + `tests/hypr`)
  - Hooks: `pre-commit` runs all of the above

---

## 5. Repository Structure

Entries marked *(planned)* are created by `dev/scaffold.sh --stage X.Y` when their stage starts.

```text
cestolshell/
├── dots/                                # Mirrors $HOME; installed via Stow
│   └── .config/
│       ├── hypr/                        # Hyprland Lua configuration
│       │   ├── hyprland.lua             # Entry point (loads hyprland/* in order)
│       │   ├── hyprland/                # monitors, env, execs, appearance, animations,
│       │   │                            # input, rules, variables, keybinds/, lib/, qs/
│       │   ├── hypridle.conf            # Idle timeouts (hyprlang)
│       │   ├── hyprlock.conf            # Lock screen (hyprlang)
│       │   └── scripts/                 # Hyprland helper scripts
│       ├── matugen/                     # Matugen config and templates (planned, 0.5)
│       └── quickshell/cestolshell/      # Quickshell bundle (planned, 0.1+)
│           ├── shell.qml
│           ├── services/                # Audio, Network, Battery, HyprlandData, etc.
│           ├── scripts/                 # Wallpaper, theming, palette sync
│           └── modules/
│               ├── common/              # Appearance, Config, Directories, M3 widgets
│               └── bar/ sidebarRight/ overview/ ...
├── assets/                              # Default fonts and wallpapers (planned, 0.2)
├── dev/                                 # Dev scripts: scaffold, test, run-nested, run-shell, checkdeps
├── docs/                                # PROJECT.md, VERSIONING.md, NOTICE.md, PARITY.md
├── sdata/dist-arch/                     # Installer package lists (core, system, theming, aur, dev)
├── tests/hypr/                          # Lua checks for the Hyprland config
├── setup                                # Entrypoint script: install, uninstall, checkdeps (planned, 0.7)
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

---

## 6. Keybinding Philosophy

Keybindings are divided into three tiers to guarantee safety and independence:

1. **Tier 1 (Essential)**: Direct interactions with Hyprland and system utilities (`kitty`, fallback launcher `rofi`, window management, workspaces, volume/brightness hardware keys). **Does not rely on Quickshell**.
2. **Tier 2 (Shell Interactions)**: Calls Quickshell modules via IPC (launcher, overview, sidebars, OSDs). Not a stage of its own: each bind lands in the same stage as the shell feature it controls, starting from 0.1.
3. **Tier 3 (Utilities & Extras)**: Workgroups, scratchpads, region capture tools, emoji pickers, submaps.

---

## 7. Development Roadmap

### MVP (Target 1.0)
* **0.0**: Standalone Hyprland Lua configuration (Tier 1 binds, `hyprlock`, fallback launcher).
* **0.1**: Core Quickshell foundation (`shell.qml`, `Config`, `Appearance`, Hyprland service, basic IPC).
* **0.2**: Material Design system tokens and primitive widgets (Button, Toggle, Slider, Card).
* **0.3**: System services integration and functional top bar.
* **0.4**: Notifications server and right sidebar (quick toggles, audio mixer, calendar).
* **0.5**: Dynamic Material You color scheme generation from wallpaper.
* **0.6**: Application launcher, workspace overview, OSDs, and session screen.
* **0.7**: Tier 3 keybindings and CLI installer (`setup`).
* **1.0**: Stabilization and daily-driver validation.

### Post 1.0 (Future Scope)
* **1.x**: Complete feature parity with `end-4` (Settings GUI, Left sidebar / AI integrations, Live overview previews).
* **2.x**: Modular styles engine, desktop widgets, customizable bar layouts.
