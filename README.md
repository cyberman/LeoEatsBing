# LeoEatsBing
LeoEatsBing is a tiny Mac OS X Leopard PowerPC helper that fetches the daily Bing wallpaper, stores it locally, and sets it as the desktop picture using native Leopard tools.

Inspired by Linux Mint Cinnamon Desklet "Bing Desktop-Hintergrundbild" by Starcross. Many kudos to the coder.

## Install

Go to Terminal.app and insert:

´´´´
mkdir -p "$HOME/Library/LaunchAgents"
cp org.quietcode.leoeatsbing.plist "$HOME/Library/LaunchAgents/"
chmod +x "$HOME/LeoEatsBing/leoeatsbing.sh"
´´´´

## Start

Go to Terminal.app and copy/paste:

´´´´
launchctl load "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
´´´´

## Stop

Go to Terminal.app and copy/paste:

´´´´
launchctl unload "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
´´´´

## Reload

After modifying 'org.quietcode.leoeatsbing.plist' file go to Terminal.app and copy/paste:

´´´´
launchctl unload "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
launchctl load "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
´´´´

## Deinstallation

Go to Terminal.app and copy/paste:

´´´´
launchctl unload "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
rm "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
rm -f "$HOME/Library/Logs/LeoEatsBing.log"
rm -f "$HOME/Library/Logs/LeoEatsBing.error.log"
´´´´

If you don't like the stored wallpapers too, go to Terminal.app and copy/paste:

´´´´
rm -rf "$HOME/Pictures/BingWallpaper"
´´´´

---

IMPORTANT: LeoEatsBing is not affiliated with Apple, Microsoft, Bing, or Ritter Sport.
It is just a small Leopard-era helper with a dangerously good appetite.

