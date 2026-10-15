#!/usr/bin/env bash
# dev/scaffold.sh - Creates the cestolshell repo structure stage by stage.
#
# Must be kept inside dev/ at the repo root and operates on the root directory
# (the folder above dev/), regardless of where it is executed from.
#
# Usage: dev/scaffold.sh [--stage STAGE|all] [DIRECTORY]
#   STAGE      one of 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 (default: 0.0)
#   DIRECTORY  alternative root (default: repo root)
#
# Each stage includes previous ones. Never overwrites existing files:
# safe to re-run with a higher stage when needed. Stages follow the roadmap
# in docs/PROJECT.md (section 7).
set -euo pipefail

STAGES=(0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7)
# GPL-3.0 text: old Arch layout first, then the SPDX one (licenses >= 20240728)
LICENSE_SRCS=(
    /usr/share/licenses/common/GPL3/license.txt
    /usr/share/licenses/spdx/GPL-3.0-or-later.txt
)

H="dots/.config/hypr"
HL="$H/hyprland"
Q="dots/.config/quickshell/cestolshell"
C="$Q/modules/common"

usage() {
    cat <<'EOF'
Usage: dev/scaffold.sh [--stage STAGE|all] [DIRECTORY]
  STAGE      one of 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 (default: 0.0)
  DIRECTORY  alternative root (default: repo root)
EOF
}

stage="0.0"
target="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
while (($# > 0)); do
    case "$1" in
    -s | --stage)
        stage="${2:?missing value for --stage}"
        shift 2
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    -*)
        echo "unknown option: $1" >&2
        usage >&2
        exit 1
        ;;
    *)
        target="$1"
        shift
        ;;
    esac
done

if [[ $stage == all ]]; then
    stage="${STAGES[-1]}"
fi

last=-1
for i in "${!STAGES[@]}"; do
    if [[ ${STAGES[$i]} == "$stage" ]]; then
        last=$i
    fi
done
if ((last < 0)); then
    echo "invalid stage: $stage (valid: ${STAGES[*]}, all)" >&2
    exit 1
fi

# ---------------------------------------------------------------- helpers

# keep <dir>: creates the directory and adds a .gitkeep ONLY if it is empty.
# If the directory already contains other files, no .gitkeep is created
# (and a leftover one is removed).
keep() {
    local dir="$target/$1"
    mkdir -p "$dir"

    # Count entries inside the directory, ignoring .gitkeep itself
    local count
    count=$(find "$dir" -mindepth 1 -maxdepth 1 ! -name '.gitkeep' | wc -l)

    if ((count == 0)); then
        if [[ ! -e "$dir/.gitkeep" ]]; then
            : >"$dir/.gitkeep"
        fi
    else
        rm -f "$dir/.gitkeep"
    fi
}

# put <file>: writes stdin to file without overwriting.
# When a new file is created, a now-useless .gitkeep in its directory is removed.
put() {
    local f="$target/$1"
    mkdir -p "$(dirname "$f")"
    if [[ -e $f ]]; then
        cat >/dev/null
        echo "already exists: $1"
    else
        cat >"$f"
        rm -f "$(dirname "$f")/.gitkeep"
        echo "created:        $1"
    fi
}

# lua_stub <file relative to hypr/> <description>
lua_stub() {
    put "$H/$1" <<EOF
-- $1: $2
EOF
}

# qml_singleton <file relative to the shell root> <description>: empty singleton
qml_singleton() {
    put "$Q/$1" <<EOF
// $1: $2
pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root
}
EOF
}

install_license() {
    if [[ -e $target/LICENSE ]]; then
        echo "already exists: LICENSE"
        return
    fi
    local src
    for src in "${LICENSE_SRCS[@]}"; do
        if [[ -r $src ]]; then
            cp "$src" "$target/LICENSE"
            echo "created:        LICENSE (GPL-3.0, from $src)"
            return
        fi
    done
    echo "WARNING: GPL-3.0 text not found (${LICENSE_SRCS[*]}), copy LICENSE manually" >&2
}

# ---------------------------------------------------------------- stages

# 0.0: standalone Hyprland Lua config (Tier 1 binds, hyprlock, fallback launcher).
# Tooling files (.gitignore, .editorconfig, stylua.toml, .luacheckrc,
# .pre-commit-config.yaml, .stowrc) are maintained by hand in the repo.
stage_0_0() {
    # README.md is maintained by hand: only create a minimal one if missing
    put README.md <<'EOF'
# cestolshell

Dotfiles for Hyprland with a QML shell built on Quickshell, Material You look.
See the full README in the repository once written.
EOF

    put CHANGELOG.md <<'EOF'
# Changelog

Format inspired by Keep a Changelog; versioning is described in
`docs/VERSIONING.md`.

## [Unreleased]

### Added

- Initial repo structure.
EOF

    install_license

    put "$H/hyprland.lua" <<'EOF'
-- Hyprland config file
local lib = require("hyprland.lib")

-- Default configs (monitors must be first)
require("hyprland.monitors")
require("hyprland.env")
require("hyprland.execs")
require("hyprland.appearance")
require("hyprland.animations")
require("hyprland.input")
require("hyprland.rules")

-- Keybinds
require("hyprland.keybinds.essential")
-- 0.1: require("hyprland.keybinds.shell")
-- 0.7: require("hyprland.keybinds.extras")

-- Shell libs
-- 0.1: require("hyprland.qs")

EOF
    # Hyprland config files
    lua_stub hyprland/monitors.lua "monitor configuration (must be loaded first)"
    lua_stub hyprland/env.lua "environment variables"
    lua_stub hyprland/execs.lua "programs to start with the session"
    lua_stub hyprland/appearance.lua "base appearance: gaps, borders, decorations"
    lua_stub hyprland/animations.lua "base animations"
    lua_stub hyprland/input.lua "keyboard, mouse, touchpad"
    lua_stub hyprland/rules.lua "window, workspace, and layer rules"
    lua_stub hyprland/variables.lua "default programs"
    lua_stub hyprland/keybinds/essential.lua "level 1: binds that only talk to Hyprland and system programs, never to the shell"

    # Libs
    lua_stub hyprland/lib/init.lua "shared helpers for the Hyprland config"

    keep "$H/hyprlock"
    keep "$H/scripts"
    keep sdata/dist-arch
    keep docs
}

# 0.1: core Quickshell foundation (shell.qml, Config, Appearance,
# Hyprland service, basic IPC).
stage_0_1() {
    put "$Q/shell.qml" <<'EOF'
//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.common
import qs.services

ShellRoot {
    id: root

    // Force singleton instantiation at startup
    property var _config: Config
    property var _appearance: Appearance
    property var _hyprlandData: HyprlandData

    // Basic IPC: qs -c cestolshell ipc call shell <function>
    IpcHandler {
        target: "shell"

        function ping(): string {
            return "pong";
        }

        function reload(): void {
            Quickshell.reload(false);
        }
    }
}
EOF

    qml_singleton modules/common/Config.qml "user options (JSON file in ~/.config/cestolshell)"
    qml_singleton modules/common/Appearance.qml "design tokens: colors, rounding, spacing, fonts, animations"
    qml_singleton modules/common/Directories.qml "standard paths (config, state, cache) used by the shell"
    # Named HyprlandData to avoid shadowing the Hyprland singleton of Quickshell.Hyprland
    qml_singleton services/HyprlandData.qml "Hyprland state not exposed by Quickshell.Hyprland (hyprctl -j)"

    # Level 2 binds are added together with the shell feature they control
    lua_stub hyprland/keybinds/shell.lua "level 2: binds towards the shell via IPC (uses hyprland.qs)"
    lua_stub hyprland/qs/init.lua "shell integration: loads and exposes the qs submodules (ipc, ...)"

    put "$HL/qs/ipc.lua" <<'EOF'
-- hyprland/qs/ipc.lua: IPC helper towards Quickshell.
-- All binds towards the shell go through here (qs ipc call), never global shortcuts.
local vars = require("hyprland.variables")

local M = {}

-- Returns a dispatcher running `qs -c <config> ipc call <target> <fn> [args...]`.
function M.call(target, fn, ...)
    local cmd = { "qs -c", vars.qs_config, "ipc call", target, fn, ... }
    return hl.dsp.exec_cmd(table.concat(cmd, " "))
end

return M
EOF
}

# 0.2: Material Design system tokens and primitive widgets.
stage_0_2() {
    keep "$C/widgets"
    keep assets/fonts
}

# 0.3: system services integration and functional top bar.
stage_0_3() {
    keep "$Q/modules/bar"
}

# 0.4: notifications server and right sidebar.
stage_0_4() {
    keep "$Q/modules/sidebarRight"
    keep "$Q/modules/notificationPopup"
}

# 0.5: dynamic Material You colors from the wallpaper.
stage_0_5() {
    put "dots/.config/matugen/config.toml" <<'EOF'
# matugen: templates and output (stage 0.5)
EOF
    keep "dots/.config/matugen/templates"
    keep "$Q/scripts"
}

# 0.6: launcher, overview, OSDs, session screen.
stage_0_6() {
    keep "$Q/modules/overview"
    keep "$Q/modules/onScreenDisplay"
    keep "$Q/modules/sessionScreen"
}

# 0.7: Tier 3 keybindings and CLI installer.
stage_0_7() {
    keep sdata/lib
    put setup <<'EOF'
#!/usr/bin/env bash
# setup: installer entrypoint. Planned subcommands: install, uninstall, checkdeps.
set -euo pipefail

echo "setup: not implemented yet (stage 0.7)" >&2
exit 1
EOF
    chmod +x "$target/setup"
    lua_stub hyprland/keybinds/extras.lua "level 3: comfort binds"
}

# ---------------------------------------------------------------- main

mkdir -p "$target"
for i in "${!STAGES[@]}"; do
    if ((i <= last)); then
        s="${STAGES[$i]}"
        echo "== stage $s"
        "stage_${s//./_}"
    fi
done

# -e, not -d: in a git worktree .git is a file
if [[ ! -e $target/.git ]] && command -v git >/dev/null 2>&1; then
    git init -q -b main "$target"
    echo "git: repository initialized (branch main)"
fi

cat <<EOF

Done: $target (up to stage $stage).
Next steps:
  - fill in the stubs created above (they are never overwritten on re-run)
  - update CHANGELOG.md, docs/PARITY.md and sdata/dist-arch/*.txt
  - commit, and tag the release once the stage is complete (docs/VERSIONING.md)
EOF
