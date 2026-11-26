# Pinned on purpose. The "Update OpenBot" workflow opens a PR within minutes of a
# new OpenBot release; Dependabot is the daily fallback.
FROM ghcr.io/nightly-labs/openbot:v0.79.0

# The upstream image runs as UID 1000, but Home Assistant mounts /data as root.
# Start as root, fix ownership, then drop to the openbot user in run.sh.
USER root
RUN apt-get update \
  && apt-get install --yes --no-install-recommends jq nginx \
  && rm -rf /var/lib/apt/lists/*
COPY run.sh /run.sh
RUN chmod 0755 /run.sh
COPY nginx.conf /etc/nginx/openbot-nginx.conf
COPY NOTICE /usr/share/doc/openbot-addon/NOTICE
ENTRYPOINT ["/run.sh"]
