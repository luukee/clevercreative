#!/usr/bin/env bash
# lighthouse/run-all.sh
# Runs Lighthouse for every URL in urls.txt. Requires lighthouse CLI and urls.txt in same dir.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
URLS_FILE="${1:-urls.txt}"

if [[ ! -f "$URLS_FILE" ]]; then
  echo "Usage: ./run-all.sh [urls-file]"
  echo "URL list not found: $URLS_FILE"
  exit 1
fi

while IFS= read -r line || [[ -n "$line" ]]; do
  line="${line%%#*}"   # strip comment
  line="$(echo "$line" | tr -d ' \t\r\n')"
  [[ -z "$line" ]] && continue

  url="$line"
  base="$(echo "$url" | sed -E 's|https?://||' | sed 's|/.*||')"
  path="$(echo "$url" | sed -E 's|https?://[^/]+||' | sed 's|^/||' | sed 's|/$||')"
  name="${base}_${path:-home}.report.html"

  echo "Running: $url -> $name"
  lighthouse "$url" --output=html --output-path="./$name" --chrome-flags="--headless"
done < "$URLS_FILE"

echo "Done."