#!/bin/sh

# Build a Mac OS X Leopard-compatible DMG for LeoEatsBing.
# This script must be run on Mac OS X because it uses hdiutil.
#
# Optional volume icon:
#   Assets/LeoEatsBingVolume.icns
# or fallback:
#   Assets/LeoEatsBing.icns

APPNAME="LeoEatsBing"
VERSION="${1:-1.0}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

DIST_DIR="$REPO_ROOT/dist"
STAGE_DIR="/tmp/${APPNAME}-dmg-stage-$$"

TEMP_DMG="$DIST_DIR/${APPNAME}-${VERSION}-temp.dmg"
DMG_NAME="${APPNAME}-${VERSION}-LeopardPPC.dmg"
DMG_PATH="$DIST_DIR/$DMG_NAME"

MOUNT_POINT=""

cleanup()
{
    if [ -n "$MOUNT_POINT" ] && [ -d "$MOUNT_POINT" ]; then
        /usr/bin/hdiutil detach "$MOUNT_POINT" >/dev/null 2>&1 || \
        /usr/bin/hdiutil detach "$MOUNT_POINT" -force >/dev/null 2>&1
    fi

    rm -rf "$STAGE_DIR"
    rm -f "$TEMP_DMG"
}

trap cleanup 0 1 2 3 15

echo "Building $DMG_NAME"

if [ ! -x /usr/bin/hdiutil ]; then
    echo "Error: hdiutil not found."
    echo "This script must be run on Mac OS X."
    exit 1
fi

cd "$REPO_ROOT" || exit 1

for required_file in README.md LICENSE leoeatsbing.sh leoeatsbing_install.sh leoeatsbing_uninstall.sh
do
    if [ ! -f "$required_file" ]; then
        echo "Error: required file missing: $required_file"
        exit 1
    fi
done

if [ ! -d docs ]; then
    echo "Error: docs directory missing."
    exit 1
fi

rm -rf "$STAGE_DIR"
rm -f "$TEMP_DMG"
rm -f "$DMG_PATH"

mkdir -p "$STAGE_DIR/$APPNAME"
mkdir -p "$DIST_DIR"

echo "Preparing staging folder..."

cp README.md "$STAGE_DIR/$APPNAME/"
cp LICENSE "$STAGE_DIR/$APPNAME/"
cp leoeatsbing.sh "$STAGE_DIR/$APPNAME/"
cp leoeatsbing_install.sh "$STAGE_DIR/$APPNAME/"
cp leoeatsbing_uninstall.sh "$STAGE_DIR/$APPNAME/"
cp -R docs "$STAGE_DIR/$APPNAME/"

# Assets are build-time resources only.
# They are not copied into the user-facing DMG payload.

chmod +x "$STAGE_DIR/$APPNAME/leoeatsbing.sh"
chmod +x "$STAGE_DIR/$APPNAME/leoeatsbing_install.sh"
chmod +x "$STAGE_DIR/$APPNAME/leoeatsbing_uninstall.sh"

cat > "$STAGE_DIR/Install LeoEatsBing.command" <<'INSTALL_EOF'
#!/bin/sh

DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$DIR/LeoEatsBing" || exit 1
sh ./leoeatsbing_install.sh

echo
echo "Press Return to close this window."
read dummy
INSTALL_EOF

cat > "$STAGE_DIR/Uninstall LeoEatsBing.command" <<'UNINSTALL_EOF'
#!/bin/sh

if [ -f "$HOME/LeoEatsBing/leoeatsbing_uninstall.sh" ]; then
    sh "$HOME/LeoEatsBing/leoeatsbing_uninstall.sh"
else
    echo "LeoEatsBing does not seem to be installed in:"
    echo "$HOME/LeoEatsBing"
fi

echo
echo "Press Return to close this window."
read dummy
UNINSTALL_EOF

chmod +x "$STAGE_DIR/Install LeoEatsBing.command"
chmod +x "$STAGE_DIR/Uninstall LeoEatsBing.command"

STAGE_SIZE_KB="$(du -sk "$STAGE_DIR" | awk '{print $1}')"
IMAGE_SIZE_MB="$(( ($STAGE_SIZE_KB / 1024) + 20 ))"

if [ "$IMAGE_SIZE_MB" -lt 20 ]; then
    IMAGE_SIZE_MB=20
fi

echo "Creating temporary read-write image..."
echo "Image size: ${IMAGE_SIZE_MB}m"

/usr/bin/hdiutil create \
    -megabytes "$IMAGE_SIZE_MB" \
    -fs HFS+ \
    -volname "$APPNAME" \
    "$TEMP_DMG" >/dev/null || exit 1

echo "Mounting temporary image..."

MOUNT_OUTPUT="$(/usr/bin/hdiutil attach "$TEMP_DMG")"
MOUNT_POINT="$(echo "$MOUNT_OUTPUT" | awk '/\/Volumes\// {print $NF; exit}')"

if [ -z "$MOUNT_POINT" ] || [ ! -d "$MOUNT_POINT" ]; then
    echo "Error: could not determine DMG mount point."
    echo "$MOUNT_OUTPUT"
    exit 1
fi

echo "Mounted at: $MOUNT_POINT"

echo "Copying files into image..."

cp -R "$STAGE_DIR/"* "$MOUNT_POINT/"

VOLUME_ICON=""

if [ -f "$REPO_ROOT/Assets/LeoEatsBingVolume.icns" ]; then
    VOLUME_ICON="$REPO_ROOT/Assets/LeoEatsBingVolume.icns"
elif [ -f "$REPO_ROOT/Assets/LeoEatsBing.icns" ]; then
    VOLUME_ICON="$REPO_ROOT/Assets/LeoEatsBing.icns"
fi

if [ -n "$VOLUME_ICON" ]; then
    echo "Adding custom volume icon:"
    echo "$VOLUME_ICON"

    cp "$VOLUME_ICON" "$MOUNT_POINT/.VolumeIcon.icns"

    if [ -x /Developer/Tools/SetFile ]; then
        /Developer/Tools/SetFile -a C "$MOUNT_POINT"
        /Developer/Tools/SetFile -a V "$MOUNT_POINT/.VolumeIcon.icns"
    else
        echo "Warning: /Developer/Tools/SetFile not found."
        echo "The .VolumeIcon.icns file was copied, but the custom icon flag was not set."
    fi
else
    echo "No volume icon found. Skipping custom volume icon."
fi

sync

echo "Detaching temporary image..."

if ! /usr/bin/hdiutil detach "$MOUNT_POINT"; then
    echo "Normal detach failed. Trying forced detach..."
    /usr/bin/hdiutil detach "$MOUNT_POINT" -force || exit 1
fi

MOUNT_POINT=""

echo "Converting to compressed read-only DMG..."

/usr/bin/hdiutil convert "$TEMP_DMG" \
    -format UDZO \
    -imagekey zlib-level=9 \
    -o "$DMG_PATH" >/dev/null || exit 1

echo "Verifying DMG..."

if ! /usr/bin/hdiutil verify "$DMG_PATH"; then
    echo "Error: DMG verification failed."
    exit 1
fi

echo
echo "Done:"
echo "$DMG_PATH"
