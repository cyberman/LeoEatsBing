#!/bin/sh

# Uninstall LeoEatsBing for the current user.

LABEL="org.quietcode.leoeatsbing"

INSTALL_DIR="$HOME/LeoEatsBing"
WALLPAPER_DIR="$HOME/Pictures/LeoEatsBingWP"
PLIST_FILE="$HOME/Library/LaunchAgents/$LABEL.plist"

APP_SUPPORT_DIR="$HOME/Library/Application Support/LeoEatsBing"

set_desktop_picture()
{
  /usr/bin/osascript \
    -e 'on run argv' \
    -e 'set imagePath to item 1 of argv' \
    -e 'tell application "Finder" to set desktop picture to POSIX file imagePath' \
    -e 'end run' \
    "$1"
}

restore_original_desktop_picture()
{
  ORIGINAL_PATH="$(/usr/bin/defaults read "$LABEL" OriginalDesktopPicturePath 2>/dev/null)"
  BACKUP_PATH="$(/usr/bin/defaults read "$LABEL" OriginalDesktopPictureBackup 2>/dev/null)"

  RESTORE_TARGET=""

  if [ -n "$ORIGINAL_PATH" ] && [ -f "$ORIGINAL_PATH" ]; then
    RESTORE_TARGET="$ORIGINAL_PATH"
  elif [ -n "$BACKUP_PATH" ] && [ -f "$BACKUP_PATH" ]; then
    BACKUP_NAME="$(basename "$BACKUP_PATH")"

    case "$BACKUP_NAME" in
      *.*)
        BACKUP_EXT=".${BACKUP_NAME##*.}"
        ;;
      *)
        BACKUP_EXT=".jpg"
        ;;
    esac

    RESTORED_COPY="$HOME/Pictures/LeoEatsBing-restored-original$BACKUP_EXT"
    cp -p "$BACKUP_PATH" "$RESTORED_COPY" || return
    RESTORE_TARGET="$RESTORED_COPY"
  fi

  if [ -n "$RESTORE_TARGET" ] && [ -f "$RESTORE_TARGET" ]; then
    set_desktop_picture "$RESTORE_TARGET"
    echo "Original desktop picture restored:"
    echo "$RESTORE_TARGET"
  else
    echo "Warning: No original desktop picture could be restored."
  fi
}

launchctl unload "$PLIST_FILE" 2>/dev/null

restore_original_desktop_picture

rm -f "$PLIST_FILE"
rm -f "$HOME/Library/Logs/LeoEatsBing.log"
rm -f "$HOME/Library/Logs/LeoEatsBing.error.log"

/usr/bin/defaults delete "$LABEL" 2>/dev/null
rm -rf "$APP_SUPPORT_DIR"
rm -rf "$INSTALL_DIR"
rm -rf "$INSTALL_DIR"

if [ "$1" = "--purge-wallpapers" ]; then
  rm -rf "$WALLPAPER_DIR"
  echo "Stored wallpapers were removed."
else
  echo "Stored wallpapers were kept in:"
  echo "$WALLPAPER_DIR"
fi

echo "LeoEatsBing is now uninstalled."
