# Contributing to cestolshell

> [!NOTE]
> **Contributions are not open yet.** cestolshell is a personal, long-term project
> built for my own enjoyment, and I want to keep its direction in my own hands until
> it reaches a stable base. External contributions (pull requests, feature requests,
> code reviews) will only be accepted **after the `1.0.0` release**.
>
> Until then, issues and PRs may be closed without review. Forks are welcome under
> the terms of the [LICENSE](LICENSE).

The sections below describe the project conventions, which will apply to contributors
once contributions open (and already apply to my own work).

## Code Style

- **Everything in English**: code, comments, docs, commits.
- **Formatting**: `.editorconfig` (UTF-8, LF, final newline). Indentation: 4 spaces everywhere
    (Lua, QML, shell, JSON/Markdown/TOML/YAML).
- **Lua**: `stylua`, `luacheck` (globals: `hl` only)
- **QML**: `qmlformat`, `qmllint`
- **Shell**: `shellcheck`
- **Commits**: Conventional Commits (`feat:`, `fix:`, `docs:`, `refactor:`, `chore:`), with an
    optional scope (`feat(hypr):`, `chore(dev):`). Small, atomic commits.

## File Headers

New source files (`.lua`, `.qml`, `.js`, `.sh`, `.py`) start with an SPDX header in the file's
comment syntax (after the shebang for scripts), followed by a one-line description:

```lua
-- SPDX-License-Identifier: GPL-3.0-only
-- Copyright (C) 2026 Cestols

-- hyprland/example.lua: what this file does
```

## Testing

```bash
dev/test.sh                  # Hyprland --verify-config + Lua checks in tests/hypr
pre-commit install
pre-commit run --all-files   # stylua, luacheck, shellcheck, qmllint, dev/test.sh
```

Then try the change in a nested session with `dev/run-nested.sh`, and run the shell
from the repo with `dev/run-shell.sh -v`. Before calling it with `qs ... ipc call` from
another terminal, `source dev/hypr-env.sh`: `qs` only sees instances on the caller's display.

`dev/test.sh` also checks that every level 2 bind calls a `target.function` declared
by an `IpcHandler` in the shell QML.

## Architecture Rules

1. **No hardcoded values** in QML → use `Appearance` singleton
2. **Layer direction**: `services` → `widgets` → `modules` (never reverse)
3. **No global variables** in Lua → modules return tables
4. **IPC first** → Hyprland ↔ Quickshell via `qs -c cestolshell ipc call`
5. **Keybinding tiers**:
   - Tier 1: Hyprland only (works without shell)
   - Tier 2: Shell IPC calls through `hyprland.qs`, added with the shell feature they control
   - Tier 3: Utilities/extras
6. **Dependencies**: add a package to `sdata/dist-arch/*.txt` in the same commit that starts using it

## Adding Code from Upstreams

If copying from `end-4/dots-hyprland`, `snowarch/iNiR` or any other project:

1. Check that the license is GPL-3.0 compatible
2. Keep the original copyright header unchanged
3. Add a copyright line for the original authors and repo, then one for your modifications
4. Add an entry to `docs/NOTICE.md`
5. Update `docs/PARITY.md`

## Versioning

See [VERSIONING.md](docs/VERSIONING.md).
