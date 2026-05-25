#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status,
# treat unset variables as an error, and catch pipeline failures.
set -euo pipefail

# Print usage instructions
print_usage() {
    echo "Usage: $(basename "$0") {logout|reboot|poweroff}" >&2
}

# Ensure exactly one argument is provided
if [[ $# -ne 1 ]]; then
    print_usage
    exit 1
fi

ACTION="$1"

# Validate the provided action
case "$ACTION" in
    logout | reboot | poweroff)
        ;;
    *)
        echo "Error: Invalid action '$ACTION'." >&2
        print_usage
        exit 1
        ;;
esac

# Ensure required binaries are available
for cmd in jq niri; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: Required command '$cmd' is not installed." >&2
        exit 1
    fi
done

# Ensure Niri is running and accessible via its IPC socket
if ! niri msg windows >/dev/null 2>&1; then
    echo "Error: Cannot communicate with Niri. Is NIRI_SOCKET set and is Niri running?" >&2
    exit 1
fi

# Gracefully request all open windows to close
close_windows_gracefully() {
    local window_ids
    window_ids=$(niri msg --json windows 2>/dev/null | jq -r '.[].id' 2>/dev/null) || return 0

    if [[ -z "$window_ids" ]]; then
        return 0
    fi

    for id in $window_ids; do
        niri msg action close-window --id "$id" &>/dev/null || true
    done

    local loops=10
    while ((loops > 0)); do
        local still_open
        still_open=$(niri msg --json windows 2>/dev/null | jq -r '.[].id' 2>/dev/null) || break
        if [[ -z "$still_open" ]]; then
            break
        fi
        sleep 0.5
        ((loops--))
    done
}

main() {
    close_windows_gracefully
    case "$ACTION" in
        logout)
            niri msg action quit --skip-confirmation
            ;;
        reboot)
            if command -v systemctl &>/dev/null; then
                systemctl reboot
            elif command -v loginctl &>/dev/null; then
                loginctl reboot
            else
                reboot
            fi
            ;;
        poweroff)
            if command -v systemctl &>/dev/null; then
                systemctl poweroff
            elif command -v loginctl &>/dev/null; then
                loginctl poweroff
            else
                poweroff
            fi
            ;;
    esac
}

main
