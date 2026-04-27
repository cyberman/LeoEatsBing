# LeoEatsBing - Troubleshooting

## Nothing happens after loading the LaunchAgent

Check the log files:

```sh
cat "$HOME/Library/Logs/LeoEatsBing.log"
cat "$HOME/Library/Logs/LeoEatsBing.error.log"
```

## The LaunchAgent does not start the script

Make sure that `leoeatsbing.sh` is executable:

```sh
chmod +x "$HOME/LeoEatsBing/leoeatsbing.sh"
```

Also make sure that the path inside `org.quietcode.leoeatsbing.plist` matches the actual location of `leoeatsbing.sh`.

## The wallpaper changes when run manually, but not through launchd

Unload and load the LaunchAgent again:

```sh
launchctl unload "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
launchctl load "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"
```

---
