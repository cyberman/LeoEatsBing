#!/bin/sh

# Install LeoEatsBing for the current user.

LABEL="org.quietcode.leoeatsbing"

detect_market()
{
  EXISTING_MARKET="$(/usr/bin/defaults read "$LABEL" Market 2>/dev/null)"

  if [ -n "$EXISTING_MARKET" ]; then
    echo "$EXISTING_MARKET"
    return
  fi

  APPLE_LOCALE="$(/usr/bin/defaults read NSGlobalDomain AppleLocale 2>/dev/null)"
  MARKET_VALUE="$(echo "$APPLE_LOCALE" | sed 's/[.@].*$//' | tr '_' '-')"

  case "$MARKET_VALUE" in
    ??-??|??-???|??-????)
      echo "$MARKET_VALUE"
      ;;
    de)
      echo "de-DE"
      ;;
    en)
      echo "en-US"
      ;;
    *)
      echo "en-US"
      ;;
  esac
}

SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="$HOME/LeoEatsBing"
WALLPAPER_DIR="$HOME/Pictures/LeoEatsBingWP"
LAUNCHAGENT_DIR="$HOME/Library/LaunchAgents"
PLIST_FILE="$LAUNCHAGENT_DIR/$LABEL.plist"

APP_SUPPORT_DIR="$HOME/Library/Application Support/LeoEatsBing"

get_current_desktop_picture()
{
  /usr/bin/osascript <<'EOF' 2>/dev/null
tell application "Finder"
    try
        set imageFile to desktop picture as alias
        set imagePath to POSIX path of imageFile
        return imagePath
    on error
        return ""
    end try
end tell
EOF
}

SCRIPT_SRC="$SOURCE_DIR/leoeatsbing.sh"
SCRIPT_DST="$INSTALL_DIR/leoeatsbing.sh"

if [ ! -f "$SCRIPT_SRC" ]; then
  echo "Error: leoeatsbing.sh not found in $SOURCE_DIR"
  exit 1
fi

mkdir -p "$INSTALL_DIR"
mkdir -p "$WALLPAPER_DIR"
mkdir -p "$LAUNCHAGENT_DIR"
mkdir -p "$HOME/Library/Logs"
mkdir -p "$APP_SUPPORT_DIR"

ORIGINAL_DESKTOP_PATH="$(get_current_desktop_picture)"

if [ -n "$ORIGINAL_DESKTOP_PATH" ] && [ -f "$ORIGINAL_DESKTOP_PATH" ]; then
  ORIGINAL_NAME="$(basename "$ORIGINAL_DESKTOP_PATH")"

  case "$ORIGINAL_NAME" in
    *.*)
      ORIGINAL_EXT=".${ORIGINAL_NAME##*.}"
      ;;
    *)
      ORIGINAL_EXT=".jpg"
      ;;
  esac

  ORIGINAL_BACKUP="$APP_SUPPORT_DIR/original-desktop-picture$ORIGINAL_EXT"

  if [ ! -f "$ORIGINAL_BACKUP" ]; then
    cp -p "$ORIGINAL_DESKTOP_PATH" "$ORIGINAL_BACKUP"
  fi

  /usr/bin/defaults write "$LABEL" OriginalDesktopPicturePath "$ORIGINAL_DESKTOP_PATH"
  /usr/bin/defaults write "$LABEL" OriginalDesktopPictureBackup "$ORIGINAL_BACKUP"
  /usr/bin/defaults write "$LABEL" OriginalDesktopPictureBackupDate "$(date '+%Y-%m-%d %H:%M:%S')"

  echo "Original desktop picture backed up:"
  echo "$ORIGINAL_BACKUP"
else
  echo "Warning: Could not detect original desktop picture."
fi

if [ "$SCRIPT_SRC" != "$SCRIPT_DST" ]; then
  cp "$SCRIPT_SRC" "$SCRIPT_DST" || exit 1
fi

if [ -f "$SOURCE_DIR/leoeatsbing_uninstall.sh" ]; then
  cp "$SOURCE_DIR/leoeatsbing_uninstall.sh" "$INSTALL_DIR/" 2>/dev/null
  chmod +x "$INSTALL_DIR/leoeatsbing_uninstall.sh" 2>/dev/null
fi

chmod +x "$SCRIPT_DST" || exit 1

launchctl unload "$PLIST_FILE" 2>/dev/null

cat > "$PLIST_FILE" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$LABEL</string>

    <key>ProgramArguments</key>
    <array>
        <string>$SCRIPT_DST</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>8</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>

    <key>StandardOutPath</key>
    <string>$HOME/Library/Logs/LeoEatsBing.log</string>

    <key>StandardErrorPath</key>
    <string>$HOME/Library/Logs/LeoEatsBing.error.log</string>
</dict>
</plist>
EOF

chmod 644 "$PLIST_FILE" || exit 1

launchctl load "$PLIST_FILE" || exit 1

MARKET="$(detect_market)"
/usr/bin/defaults write "$LABEL" Market "$MARKET"

echo "Market: $MARKET"

echo "LeoEatsBing is now installed."
echo "Wallpaper folder: $WALLPAPER_DIR"
echo "LaunchAgent: $PLIST_FILE"
