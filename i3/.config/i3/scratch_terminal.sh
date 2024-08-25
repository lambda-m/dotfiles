#!/bin/bash

# Enable debug mode
set -x

# Function to start a new instance
start_new_instance() {
    echo "Starting new instance"
    i3-msg 'exec --no-startup-id wezterm start --class scratchwezzz'
    
    # Poll for window existence
    for i in {1..50}; do  # Try for 5 seconds max
        if xdotool search --classname scratchwezzz >/dev/null 2>&1; then
            echo "Window appeared"
            i3-msg '[class="scratchwezzz"] floating enable, sticky enable, move scratchpad, border pixel 5, scratchpad show'
            return 0
        fi
        sleep 0.1
    done
    
    echo "Timed out waiting for window"
    return 1
}

# Check if the window exists
if xdotool search --classname scratchwezzz >/dev/null 2>&1; then
    echo "Window exists, toggling visibility"
    i3-msg '[class="scratchwezzz"] scratchpad show'
else
    echo "Window doesn't exist, creating new instance"
    start_new_instance
fi

echo "Script completed"