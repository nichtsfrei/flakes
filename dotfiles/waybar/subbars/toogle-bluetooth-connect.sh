#!/bin/sh

[ -z "$1" ] && printf "missing required uid\n" && exit 1 || DUID="$1"

INFO=$()
CMD="trust $DUID\nconnect $DUID"
if  bluetoothctl info $DUID | grep -q "Connected: yes"; then 
  CMD="untrust $DUID\ndisconnect $DUID"
fi

printf "$CMD\nexit\n" | bluetoothctl && \
  kill $(cat /tmp/wb_bluetooth-connect.pid)
