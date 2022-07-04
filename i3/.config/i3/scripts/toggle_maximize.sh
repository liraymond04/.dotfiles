ACTIVE_WORKSPACE=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused == true) | .name')
if [ $ACTIVE_WORKSPACE != fullscreen ]
then
    i3-msg mark _maximized_window
    gnome-terminal
    i3-msg mark _placeholder_window
    i3-msg [con_mark="_maximized_window"] focus
    i3-msg move container to workspace fullscreen
    i3-msg [con_mark="_maximized_window"] focus
else
    i3-msg swap mark "_placeholder_window"
    i3-msg [con_mark="_maximized_window"] focus
    i3-msg unmark _maximized_window
    i3-msg [con_mark="_placeholder_window"] kill
fi

# moves current window to fullscreen workspace
# gnome-terminal holds the position of the window in the previous workspace
# on toggle, the window is moved to the previous workspace
# gnome-terminal is killed