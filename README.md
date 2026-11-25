# vbrowser

A GUI browser for AI agents that cannot touch your screen.

Brave runs on a virtual X display (Xvfb) inside a container. Agents get a real,
headed browser they can click, type into and screenshot, while every window and
every synthetic input event stays on that virtual display. Your pointer, focus
and windows are never involved.

- **CDP** on `127.0.0.1:9222` for DOM-level automation (Playwright, Puppeteer,
  agent-browser, anything that speaks the DevTools Protocol)
- **Pixel-level input** through `xdotool` and `scrot`, wrapped by the `vbrowser` CLI
- **noVNC** on `http://127.0.0.1:6080/vnc.html` so a human can watch, log in to
  a site or take over
- **Persistent profile** in the `vbrowser-profile` Docker volume, so logins
  survive restarts

## Requirements

Docker. On macOS the CLI starts [colima](https://github.com/abiosoft/colima)
for you if no Docker daemon is running (`brew install colima docker`).

## Install

```sh
git clone https://github.com/mistakes5/vbrowser && cd vbrowser
docker build -t vbrowser .
ln -s "$PWD/vbrowser" ~/.local/bin/vbrowser   # or anywhere on your PATH
```

## Use

```sh
vbrowser start                 # prints the CDP and watch URLs
vbrowser open https://example.com
vbrowser shot page.png         # screenshot of the virtual display
vbrowser click 640 400         # x y [button]
vbrowser type "hello world"
vbrowser key ctrl+l Return
vbrowser scroll down 5
vbrowser stop
```

| Command | What it does |
| --- | --- |
| `start` / `stop` / `status` | Manage the container; `status` prints the browser version or `down` |
| `cdp` | Print the CDP endpoint |
| `open URL` | Open a new tab |
| `shot [file]` | Screenshot (default `/tmp/vbrowser-<epoch>.png`) |
| `click X Y [btn]`, `dclick X Y`, `move X Y` | Mouse |
| `type TEXT`, `key KEYS..` | Keyboard (`key` takes xdotool key names) |
| `scroll up\|down [n]` | Mouse wheel |
| `size` | Display geometry |

The display is 1440x900 by default. To change it, add
`-e VB_WIDTH=1920 -e VB_HEIGHT=1080` to the `docker run` line in the `vbrowser`
script and recreate the container (`docker rm -f vbrowser && vbrowser start`).

## Security notes

- Both ports are published on `127.0.0.1` only. CDP gives full control of the
  browser and the VNC view has no password, so do not publish them wider.
- Brave runs with `--no-sandbox`; the container is the isolation boundary.
- The profile volume holds whatever cookies and logins you put in it.
  `docker volume rm vbrowser-profile` wipes it.
- The container is capped at 2 GB of memory and restarts unless stopped.

## License

MIT
