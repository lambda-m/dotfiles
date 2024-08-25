#!/bin/bash

# Take a screenshot
scrot /tmp/screen_locked.png

# Pixelate the screenshot
convert /tmp/screen_locked.png -scale 10% -scale 1000% /tmp/screen_locked.png

# Lock the screen with the pixelated image
i3lock -i /tmp/screen_locked.png -n

# Remove the temporary image
rm /tmp/screen_locked.png