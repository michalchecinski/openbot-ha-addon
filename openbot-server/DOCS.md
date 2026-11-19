# OpenBot Server (Unofficial)

Runs the headless [OpenBot](https://openbot.run) server. Not affiliated with
Synthetify Labs. OpenBot is for **noncommercial use only**.

## Signing in

The app never needs a command-line login. Sign the server in with either
method below, then open OpenBot on your computer, phone or
https://openbot.run/app, sign in with the same email and pick the server.

### Option 1: Sign in through the web UI

Start the app and click **OpenBot** in the sidebar (or **Open Web UI**).
Enter your email, select **Send sign-in code**, then enter the code OpenBot
emails you. The page shows when the server is online.

### Option 2: Sign in with a one-time claim

In OpenBot choose **Add server > Other options > New server on another
computer**. OpenBot shows a command containing `OPENBOT_CLAIM=...`; copy only
the value after `OPENBOT_CLAIM=`. Paste it into the app option `claim` (you
can optionally set `server_name` to name this server). Start or restart the
app within 15 minutes — a claim works once and expires after 15 minutes.
Clear the `claim` option afterwards. The app log shows the result of the
sign-in attempt. A server that is already signed in ignores the claim.

Never share the claim: anyone who has it can sign in to your server.

## Options

Set these in the app's **Configuration** tab, save, and restart the app to
apply changes.

| Option | Default | Description |
| --- | --- | --- |
| `claim` | `""` | Optional one-time sign-in token. Clear it after successful sign-in. Already signed-in servers ignore it. |
| `server_name` | `""` | Optional name passed during claim sign-in. It does not rename an already signed-in server. |
| `env_vars` | `[]` | Extra environment variables inherited by OpenBot and its agents. Each entry has a `name` and `value`. |

Default configuration; signing in through the web UI needs no claim:

```yaml
claim: ""
server_name: ""
env_vars: []
```

For example, to provide an API key and change the agent display size:

```yaml
claim: ""
server_name: ""
env_vars:
  - name: XAI_API_KEY
    value: "YOUR_API_KEY"
  - name: OPENBOT_DISPLAY_SIZE
    value: "1920x1080"
```

Environment variable names must start with an uppercase letter and contain
only uppercase letters, digits, or underscores. The default display size is
`1280x800`. Treat API keys and claims as secrets and omit them from reports.

## Data and backups

OpenBot runs with `/data` as its home directory. This app volume persists
across restarts and updates. Include the app in your Home Assistant backups
before updating or removing it if you need to preserve its data.

## Security

Agents run commands and control a browser without per-action confirmation.
This app grants `SYS_ADMIN` so Electron's sandbox can use user namespaces
under Docker's default seccomp profile, and it disables AppArmor. Upstream's
Docker setup uses a custom seccomp profile that Supervisor cannot apply,
so this app provides weaker isolation from Home Assistant. Do not run it on
a system holding data you cannot afford to lose.

## Known issues

- If email sign-in through ingress fails, use the one-time claim method above.
- Upstream asks for `--shm-size 1g`; the Supervisor offers no such setting.
- Memory use on small hardware (Raspberry Pi) may be a problem.

## Troubleshooting and support

- **App missing from the store:** Check the repository URL and host
  architecture. Only `amd64` and `aarch64` are configured.
- **Setup page unavailable:** Check the app's **Log** tab for startup errors
  and confirm that it is running before reopening **Open Web UI**.
- **Claim sign-in failed:** Generate a fresh claim, save it, and restart
  within 15 minutes. Check the app log for the sign-in result.
- **Server missing in the client:** Confirm that the server and client use
  the same email account and check the setup page for online status.

For wrapper issues, [open a GitHub issue](https://github.com/michalchecinski/openbot-ha-addon/issues)
with the app version, Home Assistant version, architecture, reproduction
steps, and relevant logs. Remove secrets and personal information first.
For OpenBot usage and upstream support, see [openbot.run](https://openbot.run).

## License

The wrapper files are covered by the [MIT license](../LICENSE). OpenBot itself
is licensed under [PolyForm Noncommercial 1.0.0](https://polyformproject.org/licenses/noncommercial/1.0.0/)
and is for **noncommercial use only**. See [NOTICE](NOTICE) for the required
notices and commercial licensing contact.
