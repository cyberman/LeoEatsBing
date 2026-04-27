#!/bin/sh

# Install needed files for project "LeoEatsBing" to local folders.

mkdir -p "$HOME/LeoEatsBing"
mkdir -p "$HOME/Pictures/LeoEatsBingWP"
mkdir -p "$HOME/Library/LaunchAgents"

cp leoeatsbing.sh "$HOME/LeoEatsBing/"
cp org.quietcode.leoeatsbing.plist "$HOME/Library/LaunchAgents/"

chmod +x "$HOME/LeoEatsBing/leoeatsbing.sh"

launchctl load "$HOME/Library/LaunchAgents/org.quietcode.leoeatsbing.plist"

cd "$HOME/LeoEatsBing"
./leoeatsbing.sh

echo "LeoEatsBing was installed now..."

