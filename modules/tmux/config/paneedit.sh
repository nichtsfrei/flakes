#!/bin/sh

width=${2:-80%}
height=${2:-80%}
FILENAME=$(mktemp /tmp/paneedit.XXXXXX)
tmux capture-pane -pS - > "$FILENAME"
EDITOR=${EDITOR:-nvim}
tmux popup -xC -yC -w"$width" -h"$height" -E "$EDITOR" "$FILENAME"
