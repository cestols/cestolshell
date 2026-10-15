#!/usr/bin/env bash
# Print the packages listed in sdata/dist-arch/*.txt that are not installed.
# Usage: dev/checkdeps.sh [group ...]   (e.g. core system; default: all lists)

set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dir="$root/sdata/dist-arch"

if ! command -v pacman >/dev/null 2>&1; then
    echo "error: pacman not found (this script targets Arch and derivatives)" >&2
    exit 2
fi

if [[ $# -gt 0 ]]; then
    groups=("$@")
else
    groups=()
    for f in "$dir"/*.txt; do
        groups+=("$(basename "$f" .txt)")
    done
fi

missing_total=0

for group in "${groups[@]}"; do
    file="$dir/$group.txt"
    if [[ ! -f "$file" ]]; then
        echo "error: list not found: $file" >&2
        exit 2
    fi

    # Strip comments and blank lines, keep the first word of each line.
    mapfile -t pkgs < <(sed 's/#.*//' "$file" | awk 'NF {print $1}')
    [[ ${#pkgs[@]} -eq 0 ]] && continue

    # pacman -T prints only the missing packages (exit code 127 if any).
    missing="$(pacman -T "${pkgs[@]}" || true)"

    if [[ -n "$missing" ]]; then
        echo "[$group] missing:"
        missing="  ${missing//$'\n'/$'\n'  }"
        missing_total=$((missing_total + $(wc -l <<< "$missing")))
    else
        echo "[$group] ok"
    fi
done

if [[ $missing_total -gt 0 ]]; then
    echo
    echo "$missing_total package(s) missing."
    exit 1
fi
