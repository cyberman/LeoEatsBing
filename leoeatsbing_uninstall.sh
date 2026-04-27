#!/bin/sh

# Uninstall files for project "LeoEatsBing" from local folders.

launchctl unload "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"

rm -f "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
rm -f "$HOME/Library/Logs/LeoEatsBing.log"
rm -f "$HOME/Library/Logs/LeoEatsBing.error.log"

rm -rf "$HOME/LeoEatsBing"

echo "LeoEatsBing was uninstalled now..."

