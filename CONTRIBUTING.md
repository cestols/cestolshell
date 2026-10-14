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

- **Lua**: `stylua`, `luacheck` (globals: `hl` only)
- **QML**: `qmlformat`, `qmllint`
- **Shell**: `shellcheck`
- **Commits**: Conventional Commits (`feat:`, `fix:`, `docs:`, `refactor:`, `chore:`)

## Pre-commit

```bash
pre-commit install
pre-commit run --all-files
```

## Architecture Rules

1. **No hardcoded values** in QML → use `Appearance` singleton
2. **Layer direction**: `services` → `widgets` → `modules` (never reverse)
3. **No global variables** in Lua → modules return tables
4. **IPC first** → Hyprland ↔ Quickshell via `qs ipc call`
5. **Keybinding tiers**:
	- Tier 1: Hyprland only (works without shell)
	- Tier 2: Shell IPC calls
	- Tier 3: Utilities/extras

## Adding Code from Upstreams

If copying from `end-4/dots-hyprland` or `snowarch/iNiR`:
1. Keep original copyright header
2. Add entry to `docs/NOTICE.md`
3. Update `docs/PARITY.md`

## Versioning

See [VERSIONING.md](docs/VERSIONING.md).