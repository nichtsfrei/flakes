#!/bin/sh

FILENAME=$(mktemp /tmp/paneedit.XXXXXX)
tmux capture-pane -pS - > "$FILENAME"
EDITOR=${EDITOR:-nvim}
$EDITOR "$FILENAME"
