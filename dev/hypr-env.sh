#!/usr/bin/env bash
# Usage: source dev/hypr-env.sh   (DO NOT execute: must modify the current shell)

XDG_RUNTIME_DIR="/run/user/$(id -u)"
export XDG_RUNTIME_DIR

# Latest Hyprland instance with socket
sig=""
for d in "$XDG_RUNTIME_DIR"/hypr/*/; do
    if [ -S "${d}.socket.sock" ]; then
        sig=$(basename "$d")
        break
    fi
done

if [ -z "$sig" ]; then
    echo "No active Hyprland instance (are you logged in on the laptop?)" >&2
    return 1
fi
export HYPRLAND_INSTANCE_SIGNATURE="$sig"

# Wayland display (needed to launch apps or `qs` from SSH)
wl=""

for f in "$XDG_RUNTIME_DIR"/wayland-[0-9]*; do
        if [ -e "$f" ]; then
                wl=$(basename "$f")
                break
        fi
done

[ -n "$wl" ] && export WAYLAND_DISPLAY="$wl"