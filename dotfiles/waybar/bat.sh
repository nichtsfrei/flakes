#!/bin/sh
# Checks each dir of  cat /sys/class/power_supply/BAT0..BAT255/
# - energy_now / energy_full
for battery_dir in /sys/class/power_supply/BAT*/; do
  if [ -f "$battery_dir/energy_now" ] && [ -f "$battery_dir/energy_full" ]; then
    energy_now=$(cat "$battery_dir/energy_now")
    energy_full=$(cat "$battery_dir/energy_full")

    if [ "$energy_full" -ne 0 ]; then
      percentage=$((100 * energy_now / energy_full))
      if [ -f "$battery_dir/status" ]; then
        status=$(cat "$battery_dir/status")
      fi
      symbol="󰁹"
      case "$status" in
        "Charging")
          symbol="󱟠"  # Lightning bolt for Charging
          ;;
        "Discharging")
          symbol="󱟞"  # Battery with downward level for Discharging
          ;;
        *)
          ;;
      esac
      printf "|$symbol $percentage%%|"
    fi
  fi
done
