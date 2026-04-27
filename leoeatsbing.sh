#!/bin/sh

# Fetch Bing image metadata and set today's image as desktop wallpaper.

PREF_DOMAIN="org.quietcode.leoeatsbing"
DEFAULT_MARKET="en-US"

get_market()
{
  MARKET_VALUE="$(/usr/bin/defaults read "$PREF_DOMAIN" Market 2>/dev/null)"

  if [ -z "$MARKET_VALUE" ]; then
    APPLE_LOCALE="$(/usr/bin/defaults read NSGlobalDomain AppleLocale 2>/dev/null)"
    MARKET_VALUE="$(echo "$APPLE_LOCALE" | sed 's/[.@].*$//' | tr '_' '-')"
  fi

  case "$MARKET_VALUE" in
    ??-??|??-???|??-????)
      echo "$MARKET_VALUE"
      ;;
    de)
      echo "de-DE"
      ;;
    en)
      echo "en-US"
      ;;
    *)
      echo "$DEFAULT_MARKET"
      ;;
  esac
}

MARKET="$(get_market)"
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
