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

# Browser sign-in page, reached through Home Assistant ingress only (no published port).
export OPENBOT_SETUP_PAGE_PORT=8080
export OPENBOT_DISPLAY_SIZE
OPENBOT_DISPLAY_SIZE="$(jq -r '.display_size' "$OPTIONS")"

# Extra environment variables from the add-on options (e.g. provider API keys).
while IFS=$'\t' read -r name value; do
  [ -n "$name" ] && export "$name=$value"
done < <(jq -r '.env_vars[]? | [.name, .value] | @tsv' "$OPTIONS")

echo "[openbot-addon] Starting OpenBot server"
# Keep HOME pointed at /data after dropping to UID 1000, which cannot write to /root.
export HOME=/data USER=openbot LOGNAME=openbot
exec setpriv --reuid=1000 --regid=1000 --init-groups \
  --inh-caps=+sys_admin --ambient-caps=+sys_admin \
  /usr/bin/tini -- /opt/OpenBot/app/resources/hosting/openbot-container
