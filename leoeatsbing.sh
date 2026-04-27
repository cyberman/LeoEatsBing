#!/bin/sh

# Fetch Bing image metadata and set today's image as desktop wallpaper.

MARKET="de-DE"
BASE_DIR="$HOME/Pictures/LeoEatsBingWP"
DATE_STAMP="$(date +%Y%m%d)"
XML_FILE="/tmp/bing-wallpaper.xml"
OUT_FILE="$BASE_DIR/leoeatsbing-$DATE_STAMP.jpg"

mkdir -p "$BASE_DIR"

/usr/bin/curl -L -s \
  "http://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&mkt=$MARKET" \
  -o "$XML_FILE"

IMAGE_PATH="$(sed -n 's:.*<url>\(.*\)</url>.*:\1:p' "$XML_FILE" | head -1 | sed 's/&amp;/\&/g')"

if [ -z "$IMAGE_PATH" ]; then
  echo "No Bing image URL found."
  exit 1
fi

/usr/bin/curl -L -s \
  "http://www.bing.com$IMAGE_PATH" \
  -o "$OUT_FILE"

if [ ! -s "$OUT_FILE" ]; then
  echo "Image download failed."
  exit 1
fi

/usr/bin/osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$OUT_FILE\""

echo "Desktop wallpaper updated: $OUT_FILE"
