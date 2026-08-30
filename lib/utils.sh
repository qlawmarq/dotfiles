#!/bin/bash

# ====================
# Utility functions for dotfiles scripts
# ====================

# Check if running on macOS
check_macos() {
    if [ "$(uname)" != "Darwin" ] ; then
        echo "Error: This script must be run on macOS!" >&2
        exit 1
    fi
}

# Function to ask for confirmation
confirm() {
    read -p "$1 (y/N): " yn
    case $yn in
        [Yy]* ) return 0;;
        * ) return 1;;
    esac
}

# Function to print colored output
print_info() {
    printf '\033[0;34m[INFO]\033[0m %s\n' "$1"
}

print_success() {
    printf '\033[0;32m[SUCCESS]\033[0m %s\n' "$1"
}

print_warning() {
    printf '\033[0;33m[WARNING]\033[0m %s\n' "$1" >&2
}

print_error() {
    printf '\033[0;31m[ERROR]\033[0m %s\n' "$1" >&2
}

# Check command existence
command_exists() {
    command -v "$1" &> /dev/null
}

# Prompt for a value with a default
# Usage: get_user_input "Prompt text" "default value" [optional]
#
#   - default non-empty : Enter accepts the default
#   - default empty     : re-prompts until non-empty, unless the third
#                         argument is "optional", which allows an empty answer
#   - EOF (no TTY, or Ctrl-D): echoes the default and returns 1 instead of
#                         looping. Without this guard a non-interactive run
#                         spins forever.
#
# The prompt and any message go to stderr: callers use $( ), which would
# otherwise capture them into the value instead of showing them.
get_user_input() {
    local prompt="$1"
    local default="$2"
    local optional="$3"
    local input

    while true; do
        if [ -n "$default" ]; then
            printf '%s [%s]: ' "$prompt" "$default" >&2
        else
            printf '%s: ' "$prompt" >&2
        fi

        if ! IFS= read -r input; then
            printf '\n' >&2
            echo "$default"
            return 1
        fi

        if [ -n "$input" ]; then
            echo "$input"
            return 0
        fi

        if [ -n "$default" ] || [ "$optional" = "optional" ]; then
            echo "$default"
            return 0
        fi

        echo "This field cannot be empty. Please try again." >&2
    done
}
