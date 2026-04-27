#!/bin/sh

# Uninstall LeoEatsBing for the current user.

LABEL="org.quietcode.leoeatsbing"

INSTALL_DIR="$HOME/LeoEatsBing"
WALLPAPER_DIR="$HOME/Pictures/LeoEatsBingWP"
PLIST_FILE="$HOME/Library/LaunchAgents/$LABEL.plist"

launchctl unload "$PLIST_FILE" 2>/dev/null

rm -f "$PLIST_FILE"
rm -f "$HOME/Library/Logs/LeoEatsBing.log"
rm -f "$HOME/Library/Logs/LeoEatsBing.error.log"

/usr/bin/defaults delete "$LABEL" 2>/dev/null

rm -rf "$INSTALL_DIR"

if [ "$1" = "--purge-wallpapers" ]; then
  rm -rf "$WALLPAPER_DIR"
  echo "Stored wallpapers were removed."
else
  echo "Stored wallpapers were kept in:"
  echo "$WALLPAPER_DIR"
fi

echo "LeoEatsBing is now uninstalled."
