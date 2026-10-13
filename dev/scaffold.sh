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
# safe to re-run with a higher stage when needed.
set -euo pipefail

STAGES=(0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7)
LICENSE_SRC="/usr/share/licenses/common/GPL3/license.txt"

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

# qml_singleton <Name>: empty singleton in modules/common
qml_singleton() {
	put "$C/$1.qml" <<'EOF'
pragma Singleton
import Quickshell

Singleton {
}
EOF
}

install_license() {
	if [[ -e $target/LICENSE ]]; then
	echo "already exists: LICENSE"
	elif [[ -r $LICENSE_SRC ]]; then
	cp "$LICENSE_SRC" "$target/LICENSE"
	echo "created:        LICENSE (GPL-3.0, from $LICENSE_SRC)"
	else
	echo "WARNING: GPL-3.0 text not found in $LICENSE_SRC, copy LICENSE manually" >&2
	fi
}

# ---------------------------------------------------------------- stages

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

	# ... .gitignore, .editorconfig, stylua.toml, .luacheckrc,
	# .pre-commit-config.yaml and install_license stay unchanged ...

	put "$H/hyprland.lua" <<'EOF'
-- Hyprland config file

-- Default configs
require("hyprland.monitors")
require("hyprland.env")
require("hyprland.execs")
require("hyprland.appearance")
require("hyprland.animations")
require("hyprland.input")
require("hyprland.rules")

-- Keybinds
require("hyprland.keybinds.essential")
-- 0.7: require("hyprland.keybinds.extras")

-- Shell IPCs
-- 0.3: require("hyprland.keybinds.shell")
EOF
	# Hyprland config files
	lua_stub hyprland/monitors.lua "monitor configuration (must be loaded first)"
	lua_stub hyprland/env.lua "environment variables"
	lua_stub hyprland/execs.lua "programs to start with the session"
	lua_stub hyprland/appearance.lua "base appearance: gaps, borders, decorations"
	lua_stub hyprland/animations.lua "base animations"
	lua_stub hyprland/input.lua "keyboard, mouse, touchpad"
	lua_stub hyprland/rules.lua "window and layer rules"
	lua_stub hyprland/variables.lua "default programs"
	lua_stub hyprland/keybinds/essential.lua "level 1: binds that only talk to Hyprland and system programs, never to the shell"
	
	# Libs
	lua_stub hyprland/lib/init.lua "file for future use (e.g. utility functions)"

	keep "$HL/qs"
	keep "$H/hyprlock"
	keep "$H/scripts"
	keep docs
}

stage_0_2() {
	keep "$Q/modules/bar"
	keep assets/fonts
}

stage_0_3() {
	put "$HL/qs/ipc.lua" <<'EOF'
-- qs/ipc.lua: IPC helper towards Quickshell.
-- All binds towards the shell go through here (exec_cmd + qs ipc call).
local M = {}
local SHELL = "qs -c cestolshell" -- name of the Quickshell config

function M.call(target, fn)
	return hl.dsp.exec_cmd(string.format("%s ipc call %s %s", SHELL, target, fn))
end

return M
EOF
	lua_stub hyprland/keybinds/shell.lua "level 2: binds towards the shell via IPC (uses hyprland.qs.ipc)"
}

stage_0_4() {
	keep "$Q/modules/sidebarRight"
	keep "$Q/modules/notificationPopup"
}

stage_0_5() {
	put "dots/.config/matugen/config.toml" <<'EOF'
# matugen: templates and output (stage 0.5)
EOF
	keep "dots/.config/matugen/templates"
	keep "$Q/scripts"
}

stage_0_6() {
	keep "$Q/modules/overview"
	keep "$Q/modules/onScreenDisplay"
	keep "$Q/modules/sessionScreen"
}

stage_0_7() {
	keep sdata/dist-arch
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

if [[ ! -d $target/.git ]] && command -v git >/dev/null 2>&1; then
	git init -q -b main "$target"
	echo "git: repository initialized (branch main)"
fi

cat <<EOF

Done: $target (up to stage $stage).
Next steps:
	- check that $target/docs/ contains PROJECT.md and VERSIONING.md
	- check LICENSE and README
	- make the first commit for 0.0.1
EOF
