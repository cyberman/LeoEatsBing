# LeoEatsBing - Design Notes

LeoEatsBing is intentionally designed as a small Mac OS X Leopard PowerPC helper.

It is not a full application, not a widget system, not a wallpaper manager, and not a Cocoa user interface project.

The main goal is simple:

1. Fetch the daily Bing wallpaper.
2. Store it locally.
3. Set it as the current desktop picture.

## Design goals

LeoEatsBing follows a few strict design goals:

- Prefer native Mac OS X Leopard tools.
- Avoid external dependencies.
- Avoid unnecessary frameworks.
- Keep the project understandable.
- Keep the runtime small.
- Make installation and removal predictable.
- Work on PowerPC Leopard without Homebrew, MacPorts, Python, or modern macOS assumptions.

## Non-goals

LeoEatsBing does not try to be:

- a full wallpaper manager
- a Dashboard widget
- a screensaver
- a menu bar application
- a Cocoa preferences application
- a cloud service
- a general Bing API client
- a cross-platform tool

These features may be interesting in other projects, but they do not belong into the first version of LeoEatsBing.

## System integration

LeoEatsBing uses tools that already exist on Mac OS X Leopard:

- `/usr/bin/curl` for downloading metadata and image files
- `/usr/bin/osascript` for setting the desktop picture through AppleScript
- Finder for applying the desktop picture
- `launchd` for automatic execution

This keeps the project close to the operating system and avoids unnecessary runtime layers.

## launchd

Automatic execution is handled by a user LaunchAgent.

The LaunchAgent is installed here:

```sh
$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist
````

LeoEatsBing uses a LaunchAgent instead of a LaunchDaemon because setting the desktop picture is a user-session action.

A LaunchDaemon would run outside the normal user desktop context and is therefore not appropriate for this task.

## Installation model

The default installation location is:

```sh
$HOME/LeoEatsBing
```

The installer copies the executable script there and creates a user-specific LaunchAgent.

The generated LaunchAgent contains absolute paths because Leopard's `launchd` should not depend on shell expansion, relative paths, or `$HOME` inside the plist.

## Data storage

Downloaded wallpapers are stored here:

```sh
$HOME/Pictures/LeoEatsBingWP
```

The wallpaper folder is intentionally kept separate from the project folder.

Uninstalling LeoEatsBing does not remove downloaded wallpapers by default. This avoids deleting user-visible files unexpectedly.

Stored wallpapers can be removed explicitly with:

```sh
sh "$HOME/LeoEatsBing/leoeatsbing_uninstall.sh" --purge-wallpapers
```

## Logging

Log files are written to:

```sh
$HOME/Library/Logs/LeoEatsBing.log
$HOME/Library/Logs/LeoEatsBing.error.log
```

This makes background execution easier to debug without requiring additional tools.

## Why shell?

A shell script is sufficient for the first version because LeoEatsBing only needs to:

- download a small XML file
    
- extract one image URL
    
- download one image file
    
- call AppleScript once
    

A compiled application would not add meaningful value for this scope.

## Why no Cocoa app?

A Cocoa application may become useful later if LeoEatsBing grows a user interface.

For version 1, a Cocoa app would add complexity without solving a real problem.

The first version should stay small, visible, testable, and easy to remove.

## Why no Dashboard widget?

Mac OS X Leopard supports Dashboard widgets, but LeoEatsBing does not need a widget runtime.

The desktop picture is changed in the background. A visible widget would be unnecessary for the core task.

## Path and filesystem notes

The project uses a lowercase `docs` directory.

Case-only renames such as `Docs` to `docs` should not be performed on a case-insensitive Mac OS X filesystem.

Repository structure fixes should be done on a case-sensitive filesystem, for example on a Linux machine.

## Project philosophy

LeoEatsBing should stay small.

Every added feature should answer one question:

Does this help the Leopard eat Bing better?

If not, it probably does not belong into the core project.

## Possible future additions

Possible future additions, if they remain small:

- configurable market code
    
- configurable update time
    
- previous wallpaper restore helper
    
- simple image history cleanup
    
- optional `.icns` application wrapper for drag-and-drop installation
    

Larger features should remain out of scope unless the project deliberately grows into a separate application.

---

