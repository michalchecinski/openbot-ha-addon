# Home Assistant App: OpenBot Server (Unofficial)

![amd64](https://img.shields.io/badge/amd64-supported-blue.svg)
![aarch64](https://img.shields.io/badge/aarch64-supported-blue.svg)

Run the headless [OpenBot](https://openbot.run) server alongside Home Assistant.
Connect from the OpenBot desktop, mobile, or web app to work with AI agents
that can run commands and use a browser.

## About

The app provides a sign-in and server-status page through Home Assistant
ingress. Open it from the sidebar or **Open Web UI**, sign in with your email,
then select the server in an OpenBot client using the same account.

OpenBot's home directory is stored in the app's persistent `/data` volume.
Optional configuration supports one-time claim sign-in, a server name for that
claim, and environment variables such as provider API keys.

Supported architectures are `amd64` and `aarch64`. The app requires
`SYS_ADMIN` and disables AppArmor; agents act without per-action confirmation.
Read the security notes before installing.

[Installation, configuration, and security notes](DOCS.md) ·
[Changelog](CHANGELOG.md) ·
[Report an app issue](https://github.com/michalchecinski/openbot-ha-addon/issues)

This is an unofficial community app, not affiliated with Synthetify Labs.
OpenBot is for **noncommercial use only**. The wrapper files are MIT licensed;
see the [license](../LICENSE) and [required notices](NOTICE).
