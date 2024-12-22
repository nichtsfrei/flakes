#!/bin/sh
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
[ -z "$1" ] && printf "missing configuration name.\n" && exit 1 || NAME="$1"

PID_FILE="/tmp/wb_$NAME.pid"
[ -f "$PID_FILE" ] && kill $(cat $PID_FILE) && exit 0

cd $SCRIPT_DIR
[ -f "$NAME.css"] STYLE="$NAME.css" || STYLE="style.css"
waybar -c $NAME -s $STYLE &
WAYBAR_PID=$!
echo "$WAYBAR_PID" > $PID_FILE
