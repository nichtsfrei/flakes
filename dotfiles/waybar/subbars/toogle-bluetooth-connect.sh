#!/bin/sh

[ -z "$1" ] && printf "missing required uid\n" && exit 1 || DUID="$1"

INFO=$()
CMD="connect"
if  bluetoothctl info $DUID | grep -q "Connected: yes"; then 
  CMD="disconnect"
fi

printf "$CMD $DUID\nexit\n" | bluetoothctl && \
  kill $(cat /tmp/wb_bluetooth-connect.pid)
