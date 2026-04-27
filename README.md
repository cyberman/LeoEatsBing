# LeoEatsBing

LeoEatsBing is a tiny Mac OS X Leopard PowerPC helper that fetches the daily Bing™ wallpaper, stores it locally, and sets it as the desktop picture using native Leopard tools.

Inspired by the Linux Mint Cinnamon desklet “Bing Desktop-Hintergrundbild” by Starcross. Kudos to the coder.

Leo wakes up. Bing disappears. Wallpaper remains.

## Why another Bing wallpaper script?

There are many scripts that download the daily Bing wallpaper.

LeoEatsBing does not try to reinvent that idea.

Its purpose is narrower:

LeoEatsBing provides a small, dependency-free, Mac OS X Leopard PowerPC-friendly implementation that feels at home on a 2009-era Mac.

It deliberately avoids:

- Homebrew
- MacPorts
- Python
- Node.js
- Swift
- modern macOS APIs
- external wallpaper tools
- widget runtimes

Instead, it uses what Leopard already provides:

- `/usr/bin/curl`
- `/usr/bin/osascript`
- Finder
- `launchd`
- user preferences through `defaults`

The goal is not to be the most feature-rich Bing wallpaper tool.

The goal is to be the smallest sensible Leopard-native answer to a simple question:

> How would a PowerPC Mac running Mac OS X Leopard eat today's Bing wallpaper?

Many tools can fetch the daily Bing wallpaper. LeoEatsBing exists because most of them do not care about a PowerPC Leopard Mac in 2026.

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

## How to use

Please read [docs/HOW_TO_USE.md](docs/HOW_TO_USE.md).

## Troubleshooting

Please read [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md).


## Trademark notice

LeoEatsBing is not affiliated with Apple™, Microsoft™, Bing™, or Ritter Sport™.

It is just a small Leopard-era helper with a dangerously good appetite.

---
