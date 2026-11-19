# OpenBot Apps for Home Assistant (Unofficial)

[![Build app images](https://github.com/michalchecinski/openbot-ha-addon/actions/workflows/build.yaml/badge.svg?branch=main)](https://github.com/michalchecinski/openbot-ha-addon/actions/workflows/build.yaml)
![amd64](https://img.shields.io/badge/amd64-supported-blue.svg)
![aarch64](https://img.shields.io/badge/aarch64-supported-blue.svg)

Run the headless [OpenBot](https://openbot.run) server alongside Home Assistant
and connect to it from the OpenBot desktop, mobile, or web app. OpenBot provides
a workspace for AI agents that can run commands and use a browser.

This is an unofficial community app repository, not affiliated with, endorsed
by, or supported by Synthetify Labs. Apps were formerly called add-ons in Home
Assistant.

> **Status:** This app has not yet been tested on a real Home Assistant
> installation. The architectures above are configured build targets, not a
> claim of hardware validation. Read the [security notes](#security) before
> installing.

## Installation

You need a Home Assistant installation with the **Apps** store and an `amd64`
or `aarch64` host. Home Assistant Container does not support apps.

[![Add repository to Home Assistant](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fmichalchecinski%2Fopenbot-ha-addon)

Or add the repository manually:

1. Open **Settings → Apps → Install app → ⋮ → Repositories**.
2. Add this URL:

   ```text
   https://github.com/michalchecinski/openbot-ha-addon
   ```

3. Find **OpenBot Server (Unofficial)** and select **Install**.
4. Read the app's **Documentation** tab, then select **Start**.
5. Select **Open Web UI** or **OpenBot** in the sidebar. Sign in using the
   code sent to your email.
6. Open the OpenBot client on your computer or phone, or visit
   [openbot.run/app](https://openbot.run/app). Sign in with the same email and
   select the server.

On older Home Assistant versions, **Apps** and **Install app** are labeled
**Add-ons** and **Add-on Store**.

## Apps in this repository

| App | Description | Documentation |
| --- | --- | --- |
| [OpenBot Server (Unofficial)](openbot-server/README.md) | Headless OpenBot server with sign-in and status through Home Assistant ingress. | [Setup and configuration](openbot-server/DOCS.md) · [Changelog](openbot-server/CHANGELOG.md) |

### OpenBot Server features

- Sign in and check server status from the Home Assistant sidebar, without
  publishing a separate web port.
- Connect from an OpenBot client to use the server; the ingress page is for
  setup and status.
- Keep OpenBot's home directory in the app's persistent `/data` volume.
- Optionally sign in using a one-time claim and set a server name.
- Pass provider API keys and other environment variables through app options.

See the [full documentation](openbot-server/DOCS.md) for configuration examples,
known limitations, and troubleshooting.

## Security

OpenBot agents execute commands and control a browser without per-action
confirmation. This app grants `SYS_ADMIN` and disables AppArmor to support
Electron's sandbox. This gives weaker isolation from Home Assistant than
upstream's Docker setup, which uses a custom seccomp profile.

Do not run it on a system holding data you cannot afford to lose. Review the
[security details and limitations](openbot-server/DOCS.md#security) before use.

## Support and contributions

For installation, startup, or ingress problems with this app,
[open an issue](https://github.com/michalchecinski/openbot-ha-addon/issues).
Include the app version, Home Assistant version, host architecture, steps to
reproduce, and relevant app logs. Remove email addresses, API keys, and claim
tokens before posting.

For help using OpenBot itself, start with the
[upstream website and documentation](https://openbot.run).

Pull requests for fixes and documentation improvements are welcome. If you
test on Home Assistant hardware, report the hardware, architecture, versions,
and what you verified so the compatibility notes can be updated.

## License

The wrapper configuration, Dockerfile, and scripts in this repository are
covered by the [MIT license](LICENSE). OpenBot itself is licensed separately
under [PolyForm Noncommercial 1.0.0](https://polyformproject.org/licenses/noncommercial/1.0.0/)
and is for **noncommercial use only**. See [NOTICE](NOTICE) for the required
notices and commercial licensing contact.
