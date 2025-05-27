#!/bin/bash

wait_for_window_ready() {
    echo "wait"
    local win_id="$1"
    local max_attempts=50
    local attempt=0

    while (( attempt < max_attempts )); do
        if i3-msg -t get_tree | jq -e --arg id "$win_id" '
            def walk:
                .nodes[], ( .floating_nodes[]? ) | recurse(.nodes[], .floating_nodes[]?);
            walk
            | select(.window and (.window | tostring) == $id)
            | select(.floating_nodes == null or .floating != "auto_off")
        ' > /dev/null; then
            return 0
        fi
        sleep 0.05
        (( attempt++ ))
    done

    echo "Timeout waiting for window $win_id to be ready"
    return 1
}

get_window_geometry() {
    local win_id="$1"
    local geom
    geom=$(xdotool getwindowgeometry --shell "$win_id")

    while IFS='=' read -r key val; do
        case "$key" in
            WIDTH) WIN_WIDTH="$val" ;;
            HEIGHT) WIN_HEIGHT="$val" ;;
            X) WIN_X="$val" ;;
            Y) WIN_Y="$val" ;;
        esac
    done <<< "$geom"
}

apply_geometry() {
    local win_id="$1"

    # Only continue if we are going to move or resize
    if [[ -z "$X" && -z "$Y" && -z "$WIDTH" && -z "$HEIGHT" ]]; then
        return
    fi

    # Get geometry of the window
    get_window_geometry "$win_id"

    [[ -n "$WIDTH" ]] && WIN_WIDTH="$WIDTH"
    [[ -n "$HEIGHT" ]] && WIN_HEIGHT="$HEIGHT"

    # Get primary monitor offset
    local primary_info primary_geometry monitor_x monitor_y
    primary_info=$(xrandr | grep " connected primary")
    primary_geometry=$(echo "$primary_info" | grep -oP '\d+x\d+\+\d+\+\d+')
    monitor_x=$(echo "$primary_geometry" | cut -d'+' -f2)
    monitor_y=$(echo "$primary_geometry" | cut -d'+' -f3)

    # Calculate aligned X
    local final_x=""
    if [[ -n "$X" && -n "$X_ALIGN" ]]; then
        case "$X_ALIGN" in
            left)
                final_x=$((monitor_x + X))
                ;;
            right)
                final_x=$((monitor_x + SCREEN_W - WIN_WIDTH - X))
                ;;
            center)
                final_x=$((monitor_x + (SCREEN_W / 2) - (WIN_WIDTH / 2) + X))
                ;;
        esac
    elif [[ -n "$X" ]]; then
        final_x=$((monitor_x + X))
    fi

    # Calculate aligned Y
    local final_y=""
    if [[ -n "$Y" && -n "$Y_ALIGN" ]]; then
        case "$Y_ALIGN" in
            top)
                final_y=$((monitor_y + Y))
                ;;
            bottom)
                final_y=$((monitor_y + SCREEN_H - WIN_HEIGHT - Y))
                ;;
            center)
                final_y=$((monitor_y + (SCREEN_H / 2) - (WIN_HEIGHT / 2) + Y))
                ;;
        esac
    elif [[ -n "$Y" ]]; then
        final_y=$((monitor_y + Y))
    fi

    # Move window only if both X and Y are determined
    if [[ -n "$final_x" && -n "$final_y" ]]; then
        xdotool windowmove "$win_id" "$final_x" "$final_y"
    fi

    # Resize if both width and height are set
    if [[ -n "$WIDTH" && -n "$HEIGHT" ]]; then
        xdotool windowsize "$win_id" "$WIDTH" "$HEIGHT"
    fi
}

resolve_dimension() {
    local value="$1"
    local axis="$2"  # "w" or "h"
    local screen_dim


    if [[ "$axis" == "w" ]]; then
        screen_dim="$SCREEN_W"
    else
        screen_dim="$SCREEN_H"
    fi

    # Plain number
    if [[ "$value" =~ ^[0-9]+$ ]]; then
        echo "$value"
        return
    fi

    # Percent with math, e.g., 100%, 100%-10
    if [[ "$value" =~ ^([0-9]+)(%|vw|vh)([-+][0-9]+)?$ ]]; then
        local percent="${BASH_REMATCH[1]}"
        local unit="${BASH_REMATCH[2]}"
        local offset="${BASH_REMATCH[3]:-0}"

        # Accept % / vw / vh as the same (for now)
        local base=$(( screen_dim * percent / 100 ))
        local final=$(( base + offset ))

        echo "$final"
        return
    fi

    echo "Warning: Invalid dimension format: '$value'" >&2
    echo "0"
}

prepend_terminal_args() {
    local raw_command="$1"
    local terminal_cmd terminal_args remainder

    # Split into terminal and the rest
    terminal_cmd=$(echo "$raw_command" | awk '{print $1}')
    remainder="${raw_command#$terminal_cmd}"

    terminal_args=""
    [[ -n "$CLASS" ]] && terminal_args+="--class $CLASS "
    [[ -n "$TITLE" ]] && terminal_args+="--title $TITLE "

    case "$terminal_cmd" in
        kitty|alacritty|foot|wezterm)
            # Construct final command
            echo "$terminal_cmd $terminal_args$remainder"
            ;;
        *)
            # TODO
            # fix cases for GUI applications
            # right now, it can't find windows with the class
            # so it might need to use window titles instead
            # Not a known terminal — leave unchanged
            echo "$raw_command"
            ;;
    esac
}

CONFIG="$HOME/.config/i3/scratchpads.ini"
SCRATCHPAD_NAME="$1"

if [ -z "$SCRATCHPAD_NAME" ]; then
    echo "Usage: $0 <scratchpad-name>"
    exit 1
fi

# Function to extract key from INI section
get_config_value() {
    local section="$1"
    local key="$2"
    awk -F '=' -v sec="[$section]" -v key="$key" '
    $0 == sec { in_section=1; next }
    /^\[.*\]/ { in_section=0 }
    in_section && $1 ~ "^[[:space:]]*"key"[[:space:]]*$" {
        gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2; exit
    }' "$CONFIG"
}

primary_geometry=$(xrandr | grep " connected primary" | grep -oP '\d+x\d+\+\d+\+\d+')
SCREEN_W=$(echo "$primary_geometry" | cut -d'x' -f1)
SCREEN_H=$(echo "$primary_geometry" | cut -d'x' -f2 | cut -d'+' -f1)

CLASS=$(get_config_value "$SCRATCHPAD_NAME" "class")
TITLE=$(get_config_value "$SCRATCHPAD_NAME" "title")
COMMAND=$(get_config_value "$SCRATCHPAD_NAME" "command")
X=$(get_config_value "$SCRATCHPAD_NAME" "x")
Y=$(get_config_value "$SCRATCHPAD_NAME" "y")
X_ALIGN=$(get_config_value "$SCRATCHPAD_NAME" "x_align")
Y_ALIGN=$(get_config_value "$SCRATCHPAD_NAME" "y_align")

WIDTH_RAW=$(get_config_value "$SCRATCHPAD_NAME" "width")
HEIGHT_RAW=$(get_config_value "$SCRATCHPAD_NAME" "height")

if [[ -n "$WIDTH_RAW" ]]; then
    WIDTH=$(resolve_dimension "$WIDTH_RAW" "w")
fi

if [[ -n "$HEIGHT_RAW" ]]; then
    HEIGHT=$(resolve_dimension "$HEIGHT_RAW" "h")
fi

if [[ -z "$CLASS" || -z "$COMMAND" ]]; then
    echo "Error: class and command must be defined in config for [$SCRATCHPAD_NAME]"
    exit 1
fi

FULL_COMMAND=$(prepend_terminal_args "$COMMAND")
echo $FULL_COMMAND

if [[ -n "$X_ALIGN" && -z "$X" ]]; then
    echo "Warning: x_align is set to '$X_ALIGN' but x offset is missing." >&2
fi

if [[ -n "$Y_ALIGN" && -z "$Y" ]]; then
    echo "Warning: y_align is set to '$Y_ALIGN' but y offset is missing." >&2
fi

# Check if window exists with matching class
WIN_ID=$(xdotool search --class "$CLASS" | head -n 1)

if [[ -z "$WIN_ID" ]]; then
    echo "Warning: Failed to find window with class '$CLASS'." >&2
fi

if [ -z "$WIN_ID" ]; then
    # Launch the app
    i3-msg "exec --no-startup-id $FULL_COMMAND"

    # Wait for the window to appear
    for i in {1..50}; do
        WIN_ID=$(xdotool search --class "$CLASS" | head -n 1)
        [ -n "$WIN_ID" ] && break
        sleep 0.1
    done

    if [ -z "$WIN_ID" ]; then
        echo "Timed out waiting for window."
        exit 1
    fi

    # Move to scratchpad (you can also use for_window rules)
    i3-msg "[class=\"$CLASS\"] move to scratchpad"
    i3-msg "[class=\"$CLASS\"] scratchpad show"
    wait_for_window_ready "$WIN_ID"
    apply_geometry "$WIN_ID"
else
    # Toggle visibility
    FOCUSED_ID=$(xdotool getwindowfocus)
    if [ "$FOCUSED_ID" = "$WIN_ID" ]; then
        i3-msg "[class=\"$CLASS\"] move to scratchpad"
    else
        i3-msg "[class=\"$CLASS\"] scratchpad show"
        wait_for_window_ready "$WIN_ID"
        apply_geometry "$WIN_ID"
    fi
fi
