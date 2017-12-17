#!/bin/bash -e

SCREENSHOT="$HOME/Pictures/screenshot_$(date +%Y%m%d_%H%M%S).png"

if [[ "$1" == "selected" ]]; then
  scrot --select $SCREENSHOT
  xclip -selection clipboard -t 'image/png' < $SCREENSHOT
else
  scrot -m $SCREENSHOT
fi

