#!/bin/sh

output=$(niri msg --json outputs)

current_transform_eDP1=$(echo "$output" | jq -r '.["eDP-1"].logical.transform')

if [[ "$current_transform_eDP1" == "Normal" ]]; then
    niri msg output "eDP-1" transform 270
else
    niri msg output "eDP-1" transform "normal"
fi

