#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only
# Copyright (C) 2026 Cestols

# Run the test suite: Hyprland's own config parser, then the Lua checks in tests/hypr.
# Usage: dev/test.sh

set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config="$root/dots/.config/hypr/hyprland.lua"
failed=0

for cmd in Hyprland lua; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "error: $cmd not found" >&2
    exit 2
  fi
done

echo "==> Hyprland --verify-config"
# verify-config writes its log to $XDG_RUNTIME_DIR/hypr; keep it out of the live session.
log_dir="$(mktemp -d)"
trap 'rm -rf "$log_dir"' EXIT
if output="$(XDG_RUNTIME_DIR="$log_dir" Hyprland --verify-config -c "$config" 2>&1)"; then
  echo "ok    config parses"
else
  echo "FAIL  config parses"
  # Lua runtime errors stop before the parsing summary: show the tail instead.
  if [[ "$output" == *"Config parsing result"* ]]; then
    output="$(sed -n '/Config parsing result/,$p' <<< "$output")"
  fi
  tail -n 8 <<< "$output" | sed 's/^/      /'
  failed=1
fi

echo
echo "==> tests/hypr"
lua "$root/tests/hypr/test_config.lua" "$root/dots/.config/hypr" || failed=1

exit "$failed"
