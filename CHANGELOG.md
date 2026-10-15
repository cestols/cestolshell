# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/) as described in [VERSIONING.md](docs/VERSIONING.md).

## [Unreleased]

## [0.0.1] - 2026-10-15

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
