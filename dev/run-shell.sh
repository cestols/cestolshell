#!/usr/bin/env bash
# dev/run-shell.sh - Runs the Quickshell config straight from the repo (hot reload on save).
# Usage: dev/run-shell.sh [qs options...]   (e.g. -v for verbose logs)
#
# Replaces a running instance of the same config. From SSH, `source dev/hypr-env.sh` first.

# shellcheck disable=SC1091
source dev/hypr-env.sh
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
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
