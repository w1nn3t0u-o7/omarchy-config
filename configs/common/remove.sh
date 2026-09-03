# Remove unused Omarchy webapps
DESKTOP_DIR="$HOME/.local/share/applications"

for app in hey discord basecamp; do
  # Check if the webapp desktop shortcut or custom omarchy app exists
  if [ -f "$DESKTOP_DIR/${app}.desktop" ] || [ -f "$DESKTOP_DIR/${app^}.desktop" ]; then
    log_step "Removing webapp: $app"
    omarchy webapp remove "$app" 2>/dev/null || rm -f "$DESKTOP_DIR/${app}.desktop" "$DESKTOP_DIR/${app^}.desktop"
  else
    log_ok "$app already removed, skipping."
  fi
done
