#!/usr/bin/env bash
set -euo pipefail

DOCKERFILE="openbot-server/Dockerfile"
CONFIG="openbot-server/config.yaml"
CHANGELOG="openbot-server/CHANGELOG.md"

base="$(sed -nE 's#^FROM ghcr\.io/nightly-labs/openbot:([^ ]+).*#\1#p' "$DOCKERFILE" | head -1)"
if [ -z "$base" ]; then
  echo "error: could not read OpenBot base version from $DOCKERFILE" >&2
  exit 1
fi

old="$(sed -nE 's/^version: *"?([^"]+)"?.*/\1/p' "$CONFIG" | head -1)"
if [ -z "$old" ]; then
  echo "error: could not read add-on version from $CONFIG" >&2
  exit 1
fi

if [ -z "${BASE_REF:-}" ]; then
  echo "error: BASE_REF environment variable is not set" >&2
  exit 1
fi

base_version="$(git show "origin/${BASE_REF}:openbot-server/config.yaml" | sed -nE 's/^version: *"?([^"]+)"?.*/\1/p' | head -1)"
if [ -z "$base_version" ]; then
  echo "error: could not read add-on version from origin/${BASE_REF}" >&2
  exit 1
fi

if [ "$old" != "$base_version" ]; then
  echo "already bumped"
  exit 0
fi

IFS='.' read -r major minor patch <<< "$old"
new="${major}.${minor}.$((patch + 1))"

sed -i.bak -E "s/^version: .*/version: \"$new\"/" "$CONFIG" && rm "$CONFIG.bak"

{
  head -n 1 "$CHANGELOG"
  printf '\n## %s\n\n- Update OpenBot to %s.\n' "$new" "$base"
  tail -n +2 "$CHANGELOG"
} > tmp && mv tmp "$CHANGELOG"

echo "bumped ${old} -> ${new} for OpenBot ${base}"