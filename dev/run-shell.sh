#!/usr/bin/env bash
# dev/run-shell.sh - Runs the Quickshell config straight from the repo (hot reload on save).
# Usage: dev/run-shell.sh [qs options...]   (e.g. -v for verbose logs)
#
# Replaces a running instance of the same config. Loads the Hyprland/Wayland env itself
# (dev/hypr-env.sh), so it also works from SSH.
# IPC calls from another terminal need the same env: qs only finds instances on the
# caller's Wayland display, so run `source dev/hypr-env.sh` there before `qs ... ipc call`.

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Before set -e: hypr-env.sh returns non-zero when it finds no Hyprland or Wayland
# socket, and the checks below report that with a clear message.
# shellcheck disable=SC1091
source "$root/dev/hypr-env.sh"
set -euo pipefail

shell_dir="$root/dots/.config/quickshell/cestolshell"

if [[ ! -f "$shell_dir/shell.qml" ]]; then
    echo "error: $shell_dir/shell.qml not found (run: dev/scaffold.sh --stage 0.1)" >&2
    exit 1
fi

if [[ -z "${WAYLAND_DISPLAY:-}" ]]; then
    echo "error: WAYLAND_DISPLAY not set (from SSH: source dev/hypr-env.sh)" >&2
    exit 1
fi

# Kill instances of both the repo path and the stowed config, they would clash
qs kill -p "$shell_dir" >/dev/null 2>&1 || true
qs kill -c cestolshell >/dev/null 2>&1 || true

exec qs -p "$shell_dir" "$@"
