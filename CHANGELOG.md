# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/) as described in [VERSIONING.md](docs/VERSIONING.md).

## [Unreleased]

## [0.1.1] - 2026-10-17

Second version of stage 0.1.x: the first visible piece of the shell, an empty bar.

### Added

- Empty top bar (`modules/cestolshell/bar/Bar.qml`): one `PanelWindow` per monitor
    (`Variants` over `Quickshell.screens`), anchored to the top and reserving its space,
    on the layer-shell namespace `quickshell:bar`; loaded by `shell.qml`.
- Layer rule `bar` in `rules.lua` for the `quickshell:bar` namespace (blur, `ignore_alpha`).

### Changed

- Roadmap resized around visible features: every version has three numbers and is
    described in `docs/ROADMAP.md`; `dev/scaffold.sh` stages follow the new roadmap.

## [0.1.0] - 2026-10-15

First version of stage 0.1.x: the shell skeleton. It shows nothing yet, but Hyprland
starts it with the session and controls it over IPC.

### Added

- Quickshell package `quickshell/cestolshell/`: `shell.qml` with the `IpcHandler`
    `shell` (`ping`, `reload`).
- `hyprland.qs` Lua module (`qs/init.lua`, `qs/ipc.lua`): builds the
    `qs -c cestolshell ipc call` dispatchers for level 2 binds.
- Level 2 keybinds in `keybinds/shell.lua`: `SUPER + CTRL + R` reloads the shell.
- `execs.lua` starts the shell with the session.
- Tests: level 2 binds must call an `IpcHandler` function declared in the QML.
- `dev/run-shell.sh` runs the shell from the repo; `.qmlls.ini` is ignored by git and stow.

### Changed

- The main modifier and the `qs_config` name live in `variables.lua`.
- 4-space indentation for every file type.

### Fixed

- Default monitor rule uses scale 1.
- `dev/run-shell.sh` sources `hypr-env.sh` from the repo root.

## [0.0.1] - 2026-10-15

Stage 0.0.x complete: standalone Hyprland config (Lua modules, level 1 keybinds,
fallback launcher, `hypridle` and `hyprlock`), usable without the shell.

### Added

- Test suite: `dev/test.sh` runs `Hyprland --verify-config` and the Lua checks in `tests/hypr/`
    (strict `hl` mock generated from Hyprland's stubs, callback bodies, duplicate rules and binds,
    level 1 binds never calling the shell, no global variables besides `hl`).
- `hypr-tests` pre-commit hook.
- `hypridle.conf`: dim after 2.5 min, lock after 5, screen off after 5.5, suspend after 30;
    locks before sleep. `SUPER + L` now locks the session.
- `hyprlock.conf`: blurred desktop snapshot, clock, date, password field, user and keyboard
    layout, with the static M3 palette of `appearance.lua`.

## [0.0.0] - 2026-10-14

### Added

- Repository structure, tooling configs (`.editorconfig`, `stylua.toml`, `.luacheckrc`,
    `.pre-commit-config.yaml`, `.stowrc`) and documentation (`docs/`).
- Development helpers in `dev/`: `scaffold.sh`, `run-nested.sh`, `run-shell.sh`,
    `hypr-env.sh`, `checkdeps.sh`.
- Arch/CachyOS package lists in `sdata/dist-arch/` (core, system, theming, aur, dev).
- Hyprland Lua config modules: monitors (fallback rule), env, session autostart,
    appearance with static M3 colors, M3 motion curves and animations, input and touchpad
    gestures, window/workspace/layer rules, default programs in `variables.lua`.
- Level 1 keybindings in `keybinds/essential.lua` (see the table in `README.md`).

### Changed

- `.luacheckrc` declares `hl` as the only global.
