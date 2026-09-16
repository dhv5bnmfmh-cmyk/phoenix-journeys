#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../.." && pwd)"
out="$repo_root/app/assets/images/backgrounds/generated/beijing/forbidden-city/wuying-hall-light-limit"
payload="$out/contact.webp.b64"
source_webp="$out/.story2-contact.webp"

names=(
  01-palace-axis-soft-morning
  02-roofline-haze
  03-red-wall-eaves
  04-doorway-observer
  05-golden-courtyard
  06-courtyard-profile
  07-old-paper-shadow
  08-old-paper-light
  09-palace-wall-sunset
  10-quiet-palace-edge
)

mkdir -p "$out"
test -s "$payload"
base64 -d "$payload" > "$source_webp"

for i in $(seq 0 9); do
  col=$((i % 5))
  row=$((i / 5))
  x=$((col * 90))
  y=$((row * 160))
  target="$out/${names[$i]}.webp"
  ffmpeg -hide_banner -loglevel error -y -i "$source_webp" \
    -vf "crop=90:160:${x}:${y},scale=360:640:flags=lanczos" \
    -frames:v 1 -c:v libwebp -quality 68 "$target"
  test -s "$target"
done

rm -f "$source_webp"
echo "Story 2 backgrounds materialized: ${#names[@]}"
