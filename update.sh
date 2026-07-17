#!/usr/bin/env bash
# Regenerate sources.json with the latest oh-my-pi version and per-system hashes.
# Pin a version with: ./update.sh 17.0.1
set -euo pipefail
cd "$(dirname "$0")"

ver="${1:-$(curl -fsSL https://api.github.com/repos/can1357/oh-my-pi/releases/latest | jq -r '.tag_name | ltrimstr("v")')}"
[ -n "$ver" ] && [ "$ver" != "null" ] || { echo "could not determine latest version" >&2; exit 1; }

base="https://github.com/can1357/oh-my-pi/releases/download/v$ver"

# system -> release asset
systems="x86_64-linux:omp-linux-x64 aarch64-linux:omp-linux-arm64 x86_64-darwin:omp-darwin-x64 aarch64-darwin:omp-darwin-arm64"

json=$(jq -n --arg version "$ver" '{version: $version, systems: {}}')
for entry in $systems; do
  sys="${entry%%:*}"; asset="${entry#*:}"
  sri=$(nix store prefetch-file --json "$base/$asset" | jq -r .hash)
  json=$(jq --arg s "$sys" --arg a "$asset" --arg h "$sri" \
    '.systems[$s] = {asset: $a, hash: $h}' <<<"$json")
done

printf '%s\n' "$json" > sources.json
echo "updated to $ver"
