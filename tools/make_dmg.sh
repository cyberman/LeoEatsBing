#!/bin/sh

# Build a Mac OS X Leopard-compatible DMG for LeoEatsBing.
# This script must be run on Mac OS X because it uses hdiutil.

APPNAME="LeoEatsBing"
VERSION="${1:-1.0}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

DIST_DIR="$REPO_ROOT/dist"
STAGE_DIR="/tmp/${APPNAME}-dmg-stage-$$"
DMG_NAME="${APPNAME}-${VERSION}-LeopardPPC.dmg"
DMG_PATH="$DIST_DIR/$DMG_NAME"

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
mkdir -p "$STAGE_DIR/$APPNAME"
mkdir -p "$DIST_DIR"

cp README.md "$STAGE_DIR/$APPNAME/"
cp LICENSE "$STAGE_DIR/$APPNAME/"
cp leoeatsbing.sh "$STAGE_DIR/$APPNAME/"
cp leoeatsbing_install.sh "$STAGE_DIR/$APPNAME/"
cp leoeatsbing_uninstall.sh "$STAGE_DIR/$APPNAME/"
cp -R docs "$STAGE_DIR/$APPNAME/"

if [ -d Assets ]; then
    cp -R Assets "$STAGE_DIR/$APPNAME/"
fi

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

rm -f "$DMG_PATH"

/usr/bin/hdiutil create \
    -volname "$APPNAME" \
    -srcfolder "$STAGE_DIR" \
    -ov \
    -format UDZO \
    "$DMG_PATH"

RESULT=$?

rm -rf "$STAGE_DIR"

if [ "$RESULT" -ne 0 ]; then
    echo "Error: DMG build failed."
    exit "$RESULT"
fi

/usr/bin/hdiutil verify "$DMG_PATH"

echo
echo "Done:"
echo "$DMG_PATH"
