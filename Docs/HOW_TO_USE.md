# LeoEatsBing - How to use

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

---
