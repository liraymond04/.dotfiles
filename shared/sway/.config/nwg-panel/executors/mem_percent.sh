#!/usr/bin/env bash
# Used by nwg-panel preset: bash -c exec${IFS}${XDG_CONFIG_HOME:-$HOME/.config}/nwg-panel/executors/mem_percent.sh
# Same used/total semantics as gopsuinfo -i m, shown as a percentage for nwg-panel (icon path + label).

set -euo pipefail

mapfile -t lines < <(gopsuinfo -i m 2>/dev/null)
icon="${lines[0]:-}"

if [[ "${lines[1]-}" =~ ^([0-9]+)/([0-9]+) ]]; then
  used="${BASH_REMATCH[1]}"
  total="${BASH_REMATCH[2]}"
  if (( total > 0 )); then
    pct=$(awk -v u="$used" -v t="$total" 'BEGIN { printf "%.1f%%", 100 * u / t }')
  else
    pct="0%"
  fi
else
  pct="—"
fi

printf '%s\n%s\n' "$icon" "$pct"
