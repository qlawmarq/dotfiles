# Step: grant macOS notification permission for the notify hooks
#
# osascript's `display notification` needs a one-time permission grant,
# which macOS only prompts for from an app with a UI. Running the script
# once from Script Editor is the supported way to trigger that prompt.

if [ ! -f "$CLAUDE_DIR/hooks/notify.sh" ]; then
    print_warning "notify.sh not deployed - run the 'hooks' step first"
    return 0
fi

if [ ! -t 0 ]; then
    print_info "Non-interactive - skipping notification permission setup"
    return 0
fi

if ! confirm "Set up notification permissions for hooks?"; then
    print_info "Skipped"
    return 0
fi

echo ""
print_info "A test notification script will open in Script Editor."
echo ""

TEMP_SCRIPT=$(mktemp).scpt
cat > "$TEMP_SCRIPT" <<'APPLESCRIPT'
display notification "Test notification from Claude Code" with title "Notification Permission Request"
APPLESCRIPT

open -a "Script Editor" "$TEMP_SCRIPT"

echo "In Script Editor:"
echo "  1. Click Run (>)"
echo "  2. Grant notification permission when prompted"
echo "  3. A notification should appear"
echo ""

if confirm "Have you run the script and granted permission?"; then
    print_success "Notification permissions setup complete"
else
    print_info "You can grant permissions later by re-running this step"
fi
rm -f "$TEMP_SCRIPT"
