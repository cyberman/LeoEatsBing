# LeoEatsBing

LeoEatsBing is a tiny Mac OS X Leopard PowerPC helper that fetches the daily Bing™ wallpaper, stores it locally, and sets it as the desktop picture using native Leopard tools.

Inspired by the Linux Mint Cinnamon desklet “Bing Desktop-Hintergrundbild” by Starcross. Kudos to the coder.

Leo wakes up. Bing disappears. Wallpaper remains.

## Project scope

LeoEatsBing is intentionally small.

It does one thing:

1. Fetch the daily Bing wallpaper.
    
2. Store it locally.
    
3. Set it as the desktop picture.
    

It is not a widget, screensaver, menu bar app, or full wallpaper manager.

## Requirements

- Mac OS X 10.5.8 Leopard
- PowerPC Mac
- Internet connection
- `/usr/bin/curl`
- `/usr/bin/osascript`
- Finder

No Homebrew, MacPorts, Python, Cocoa app bundle, or widget runtime is required.

## Installation location

The default setup assumes that the project folder is located here:

```sh
$HOME/LeoEatsBing
````

If you use another location, edit `org.quietcode.leoeatsbing.plist` and adjust the path to `leoeatsbing.sh`.

## Install

Open Terminal.app and run:

```sh
mkdir -p "$HOME/Library/LaunchAgents"
cd "$HOME/LeoEatsBing"
chmod +x leoeatsbing.sh
cp org.quietcode.leoeatsbing.plist "$HOME/Library/LaunchAgents/"
```

## Test manually

Before enabling automatic startup, run LeoEatsBing once manually:

```sh
cd "$HOME/LeoEatsBing"
./leoeatsbing.sh
```

If everything works, the current Bing wallpaper should be downloaded and set as your desktop picture.

## Start automatically

Load the LaunchAgent:

```sh
launchctl load "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
```

LeoEatsBing will now run according to the schedule defined in `org.quietcode.leoeatsbing.plist`.

## Stop

Unload the LaunchAgent:

```sh
launchctl unload "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
```

This stops automatic execution for the current user.

## Reload after changes

After modifying `org.quietcode.leoeatsbing.plist`, unload and load it again:

```sh
launchctl unload "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
launchctl load "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
```

## Disable autostart

To stop automatic wallpaper updates and remove the LaunchAgent file:

```sh
launchctl unload "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
rm -f "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
```

The downloaded wallpapers and the project folder are not removed.

## Logs

LeoEatsBing writes log output to:

```sh
$HOME/Library/Logs/LeoEatsBing.log
$HOME/Library/Logs/LeoEatsBing.error.log
```

To inspect the logs:

```sh
cat "$HOME/Library/Logs/LeoEatsBing.log"
cat "$HOME/Library/Logs/LeoEatsBing.error.log"
```

## Uninstall

To remove the LaunchAgent and logs:

```sh
launchctl unload "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
rm -f "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
rm -f "$HOME/Library/Logs/LeoEatsBing.log"
rm -f "$HOME/Library/Logs/LeoEatsBing.error.log"
```

Optional: remove downloaded wallpapers:

```sh
rm -rf "$HOME/Pictures/BingWallpaper"
```

Optional: remove the project folder:

```sh
rm -rf "$HOME/LeoEatsBing"
```

# Troubleshooting

Please read TROUBLESHOOTING.md.


## Trademark notice

LeoEatsBing is not affiliated with Apple™, Microsoft™, Bing™, or Ritter Sport™.

It is just a small Leopard-era helper with a dangerously good appetite.

---
