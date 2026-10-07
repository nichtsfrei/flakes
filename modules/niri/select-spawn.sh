#!/bin/sh

find_windows() {
    niri msg --json windows | jq -r --arg pat "$1" \
        '.[] | select((.app_id // "" | ascii_downcase | test($pat; "i")) or (.title // "" | ascii_downcase | test($pat; "i"))) | "\(.id)\t\(.app_id // "unknown") - \(.title)"'
}

focus_id() {
    niri msg action focus-window --id "$1"
}

program() {
    name="$1"
    if [ -z "$name" ]; then
        echo "usage: $0 program NAME" >&2
        exit 1
    fi

    windows=$(find_windows "$name")

    if [ -n "$windows" ]; then
        id=$(printf '%s\n' "$windows" | head -n1 | cut -f1)
        focus_id "$id"
    else
        niri msg action spawn -- "$name"
    fi
}

switcher() {
    windows=$(niri msg --json windows | jq -r \
      'sort_by(.is_focused)[] | "\(.id)\t\(.app_id // "unknown") - \(.title)"')

    [ -z "$windows" ] && exit 0

    selected=$(printf '%s\n' "$windows" | fuzzel --dmenu --prompt "  Window: ")
    [ -z "$selected" ] && exit 0

    id=${selected%%	*}   # up to first literal tab ( parameter expansion)
    focus_id "$id"
}

case "${1:-}" in
    program) shift; program "$@" ;;
    *)       switcher ;;
esac
