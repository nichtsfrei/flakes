#!/bin/sh

[ -z "$1"] && SOCKET_PATH="$XDG_RUNTIME_DIR/lkbd.sock" || SOCKET_PATH="$1"
echo "using $SOCKET_PATH"

# Infinite loop to continuously call nc -U
while true; do
  date
  echo 'L' | nc -U "$SOCKET_PATH"  # Connect to the Unix socket
  date
  sleep 1
done

