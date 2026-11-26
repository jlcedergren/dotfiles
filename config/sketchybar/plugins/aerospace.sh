#!/usr/bin/env bash
# ~/.config/sketchybar/plugins/aerospace.sh
# chmod +x this file.
#
# Called as: aerospace.sh <workspace-id>
# $NAME and $FOCUSED_WORKSPACE come from sketchybar.

export PATH="/opt/homebrew/bin:$PATH"

SID="$1"

# Fallback so the script also works when triggered without the variable set.
if [ -z "$FOCUSED_WORKSPACE" ]; then
  FOCUSED_WORKSPACE="$(aerospace list-workspaces --focused)"
fi

ACCENT_FG=0xff181926
FG=0xffcad3f5

if [ "$SID" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" drawing=on \
                           background.drawing=on \
                           icon.color=$ACCENT_FG
elif [ -z "$(aerospace list-windows --workspace "$SID" 2>/dev/null)" ]; then
  # Empty and unfocused -> hide it, which keeps the pill short.
  # Delete this branch if you'd rather always see 1-9.
  sketchybar --set "$NAME" drawing=off
else
  sketchybar --set "$NAME" drawing=on \
                           background.drawing=off \
                           icon.color=$FG
fi
