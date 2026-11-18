ARG OPENBOT_VERSION=latest
FROM ghcr.io/nightly-labs/openbot:${OPENBOT_VERSION}

# The upstream image runs as UID 1000, but Home Assistant mounts /data as root.
# Start as root, fix ownership, then drop to the openbot user in run.sh.
USER root
RUN apt-get update \
  && apt-get install --yes --no-install-recommends jq nginx \
  && rm -rf /var/lib/apt/lists/*
COPY run.sh /run.sh
RUN chmod 0755 /run.sh
COPY nginx.conf /etc/nginx/openbot-nginx.conf
ENTRYPOINT ["/run.sh"]
