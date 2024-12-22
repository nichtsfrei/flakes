#!/bin/sh

STATE_FILE="/tmp/osk_visible_state"

if [ ! -f "$STATE_FILE" ]; then
    echo "0" > "$STATE_FILE"
fi

current_state=$(cat "$STATE_FILE")

if [ "$current_state" == "1" ]; then
    busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b false
    echo "0" > "$STATE_FILE"
else
    busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b true
    echo "1" > "$STATE_FILE"
fi
