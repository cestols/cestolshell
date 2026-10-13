# Contributing to cestolshell

## Code Style

- **Lua**: `stylua` (2 spaces), `luacheck` (globals: `hl` only)
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