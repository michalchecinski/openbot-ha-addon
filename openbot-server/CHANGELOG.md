# Changelog

## 0.1.12

- Update OpenBot to 0.81.0.

## 0.1.11

- Update OpenBot to 0.80.0.

## 0.1.10

- Exclude caches, provider CLIs and voice models from Home Assistant backups.
  After a restore, download the provider CLIs again in OpenBot.
- Exclude `node_modules` in agent workspaces from backups. After a restore, install
  the packages of those projects again.
- Stop OpenBot while Home Assistant backs it up, so that its database is copied
  safely. It starts again after the backup; running agent turns are interrupted.

## 0.1.9

- Update OpenBot to 0.78.0.

## 0.1.8

- Update OpenBot to 0.77.0.

## 0.1.7

- Update OpenBot to 0.76.1.

## 0.1.6

- Add the OpenBot icon to the add-on card.

## 0.1.5

- Update OpenBot to 0.74.0.

## 0.1.4

- Remove the display_size option (OpenBot defaults to 1280x800; OPENBOT_DISPLAY_SIZE can still be set via env_vars).

## 0.1.3

- Show claim and server_name in the Configuration tab (empty defaults).

## 0.1.2

- Optional one-time claim sign-in (`claim`, `server_name` options).

## 0.1.1

- Fix sign-in page behind ingress: proxy rewrites absolute /api paths; remove deprecated build.yaml; show in sidebar.

## 0.1.0

- Initial scaffold (untested).
