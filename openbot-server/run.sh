#!/bin/bash
# Start OpenBot as the unprivileged openbot user, keeping CAP_SYS_ADMIN
# as an ambient capability so the Electron sandbox can use user namespaces.
set -euo pipefail

OPTIONS=/data/options.json

# /data is the add-on's persistent volume and is also OpenBot's home folder.
if [ "$(stat -c %u /data)" != "1000" ]; then
  echo "[openbot-addon] Fixing ownership of /data (first start)"
  chown 1000:1000 /data
  # Only touch what OpenBot created; options.json stays root-owned.
  find /data -mindepth 1 -maxdepth 1 ! -name options.json -exec chown -R 1000:1000 {} +
fi

# Browser sign-in page: OpenBot serves it on 8081, nginx proxies it on 8080
# for Home Assistant ingress and rewrites the page's absolute /api paths.
export OPENBOT_SETUP_PAGE_PORT=8081

# Extra environment variables from the add-on options (e.g. provider API keys).
while IFS=$'\t' read -r name value; do
  [ -n "$name" ] && export "$name=$value"
done < <(jq -r '.env_vars[]? | [.name, .value] | @tsv' "$OPTIONS")

# nginx (daemonizes) proxies 8080 -> 8081 and rewrites /api paths for ingress.
nginx -c /etc/nginx/openbot-nginx.conf

claim_signin() {
  set +e
  local claim
  claim="$(jq -r '.claim // empty' "$OPTIONS")"
  [ -z "$claim" ] && return
  claim="${claim#OPENBOT_CLAIM=}"
  local name
  name="$(jq -r '.server_name // empty' "$OPTIONS")"

  as_openbot() { setpriv --reuid=1000 --regid=1000 --init-groups env HOME=/data USER=openbot LOGNAME=openbot "$@"; }

  local i status ok=0
  for i in $(seq 1 60); do
    if status="$(as_openbot openbot status 2>&1)"; then
      ok=1
      break
    fi
    sleep 2
  done
  if [ "$ok" -ne 1 ]; then
    echo "[openbot-addon] claim: server did not start in time"
    return
  fi

  if grep -q '^Account: [^ ]*@' <<<"$status"; then
    echo "[openbot-addon] claim: already signed in, claim not used. Clear the claim option."
    return
  fi

  if printf '%s\n' "$claim" | as_openbot openbot login --claim ${name:+--name "$name"}; then
    echo "[openbot-addon] claim: sign-in succeeded. You can clear the claim option."
  else
    echo "[openbot-addon] claim: sign-in failed (a claim works once and expires after 15 minutes; make a new one)."
  fi
  unset claim
}

echo "[openbot-addon] Starting OpenBot server"
# Keep HOME pointed at /data after dropping to UID 1000, which cannot write to /root.
export HOME=/data USER=openbot LOGNAME=openbot

( claim_signin ) &
exec setpriv --reuid=1000 --regid=1000 --init-groups \
  --inh-caps=+sys_admin --ambient-caps=+sys_admin \
  /usr/bin/tini -- /opt/OpenBot/app/resources/hosting/openbot-container
