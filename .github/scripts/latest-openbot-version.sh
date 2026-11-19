#!/usr/bin/env bash
# Prints the newest stable OpenBot version (X.Y.Z) published to GHCR.
set -euo pipefail

repo="nightly-labs/openbot"
headers="$(mktemp)"
trap 'rm -f "$headers"' EXIT

token="$(curl -fsS "https://ghcr.io/token?scope=repository:${repo}:pull" | jq -r .token)"
if [ -z "$token" ] || [ "$token" = "null" ]; then
  echo "error: could not get a GHCR pull token for ${repo}" >&2
  exit 1
fi

tags="$(curl -fsS -D "$headers" -H "Authorization: Bearer ${token}" \
  "https://ghcr.io/v2/${repo}/tags/list?n=1000")"

# A Link header means the tag list is paginated and the newest tag may be missing.
if grep -qi '^link:' "$headers"; then
  echo "error: tag list for ${repo} is paginated, extend this script to follow it" >&2
  exit 1
fi

latest="$(jq -r '.tags[]' <<< "$tags" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -1 || true)"
if [ -z "$latest" ]; then
  echo "error: no stable X.Y.Z tag found for ${repo}" >&2
  exit 1
fi

echo "$latest"
