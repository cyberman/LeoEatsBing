# LeoEatsBing

LeoEatsBing is a tiny Mac OS X Leopard PowerPC helper that fetches the daily Bing&trade; wallpaper, stores it locally, and sets it as the desktop picture using native Leopard tools.

Inspired by Linux Mint Cinnamon Desklet "Bing Desktop-Hintergrundbild" by Starcross. Kudos to the coder.

## Install

Go to Terminal.app and copy/paste:

```
mkdir -p "$HOME/Library/LaunchAgents"
cp org.quietcode.leoeatsbing.plist "$HOME/Library/LaunchAgents/"
chmod +x "$HOME/LeoEatsBing/leoeatsbing.sh"
```

## Start

Go to Terminal.app and copy/paste:

```
launchctl load "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
```

## Stop

Go to Terminal.app and copy/paste:

```
launchctl unload "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
```

## Reload

After modifying `org.quietcode.leoeatsbing.plist` file go to Terminal.app and copy/paste:

```
launchctl unload "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
launchctl load "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
```

## Deactivate

If you wanna stop automatic loading of wallpapers, go to Terminal.app and copy/paste:
```
launchctl unload "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
rm -f "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
rm -f "$HOME/Library/Logs/LeoEatsBing.log"
rm -f "$HOME/Library/Logs/LeoEatsBing.error.log"
```

## Deinstall

Go to Terminal.app and copy/paste:

```
launchctl unload "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
rm "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
rm -f "$HOME/Library/Logs/LeoEatsBing.log"
rm -f "$HOME/Library/Logs/LeoEatsBing.error.log"
```

*Optional:* If you don't like also the stored wallpapers anymore, go to Terminal.app and copy/paste:

```
rm -rf "$HOME/Pictures/BingWallpaper"
```

---

**IMPORTANT:** LeoEatsBing is not affiliated with Apple&trade;, Microsoft&trade;, Bing&trade; or Ritter Sport&trade;.

It is just a small Leopard-era helper with a dangerously good appetite.

