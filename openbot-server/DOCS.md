# OpenBot Server (Unofficial)

Runs the headless [OpenBot](https://openbot.run) server. Not affiliated with
Synthetify Labs. OpenBot is for **noncommercial use only**.

## First login

Start the add-on and click **OpenBot** in the sidebar (or **Open Web UI**).
Enter your email, select **Send sign-in code**, then enter the code OpenBot
emails you. The page shows when the server is online. Then open OpenBot on
your computer, phone or https://openbot.run/app, sign in with the same email
and pick the server.

The page can only show status and sign in. To sign out or get a phone
pairing code, use a terminal with Docker access:
`docker exec -it addon_<repo-hash>_openbot openbot logout` or
`openbot mobile-connect`.

## Options

- `display_size`: virtual display for agents, `WIDTHxHEIGHT`.
- `env_vars`: extra environment variables (provider API keys such as
  `XAI_API_KEY`). Agents inherit them.

## Security

Agents run commands and control a browser without per-action confirmation.
This add-on needs `SYS_ADMIN` and no AppArmor profile, so isolation from
Home Assistant is weaker than upstream's Docker setup. Do not run it on a
system holding data you cannot afford to lose.

## Known issues

- Untested on real Home Assistant so far.
- The setup page checks the request origin; it may reject requests that arrive
  through ingress. If so, sign-in falls back to `docker exec -it ... openbot login`.
- Upstream asks for `--shm-size 1g`; the Supervisor offers no such setting.
- Memory use on small hardware (Raspberry Pi) may be a problem.
