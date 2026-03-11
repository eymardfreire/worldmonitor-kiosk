# World Monitor Kiosk for DietPi (Raspberry Pi)

Boot your Pi straight into [World Monitor](https://worldmonitor.app) in full-screen—no desktop, no LXDE. Just power on → World Monitor.

## One-line install (on the Pi)

On your **Raspberry Pi (DietPi)** — fresh install or existing — run:

```bash
curl -sL https://raw.githubusercontent.com/eymardfreire/worldmonitor-kiosk/main/install.sh | sudo bash
```

No URL or repo name to type. To use a different fork: `... | sudo bash -s YOUR_USERNAME/worldmonitor-kiosk`

The script will:

1. Install Chromium and xinit if missing
2. Download and install the kiosk script
3. Set DietPi autostart to **Custom (foreground, with autologin)**. Nothing else is removed (safe for clean installs)

Then **reboot**: `sudo reboot`. After reboot, World Monitor should appear. On Pi 3B (1 GB RAM), enable swap in `dietpi-config` if needed.

---

## Not fullscreen? (option 11)

If World Monitor opens in a window with grey borders, F11 often does nothing when Chromium is started by DietPi. To force fullscreen, edit the Chromium autostart script on the Pi:

```bash
# 1. See how Chromium is started (path may be "installed" or "installations", with or without .sh):
cat /var/lib/dietpi/dietpi-software/installed/chromium-autostart.sh
# or: cat /var/lib/dietpi/dietpi-software/installations/chromium-autostart

# 2. Set resolution so the window fills the screen (edit /boot/dietpi.txt and add or change):
#    SOFTWARE_CHROMIUM_RES_X=1920
#    SOFTWARE_CHROMIUM_RES_Y=1080
#    (use your monitor resolution). The script uses these; default 1280x720 causes grey borders.

# 3. Optionally add --start-fullscreen: edit the script and add it to CHROMIUM_OPTS, e.g.:
sudo nano /var/lib/dietpi/dietpi-software/installed/chromium-autostart.sh
# or: sudo nano /var/lib/dietpi/dietpi-software/installations/chromium-autostart

# 4. Reboot
sudo reboot
```

Ensure the line that launches Chromium includes `--kiosk` and `--start-fullscreen`; add `--window-size=1920,1080` and `--window-position=0,0` if needed for your resolution.

---

## What you get

- **No desktop**: LXDE is removed; only X + Chromium for the kiosk.
- **Full-screen**: World Monitor in kiosk mode with the default URL (global view, 7d, layers).
- **Autostart**: Boot → auto-login → Chromium kiosk.

## Requirements

- DietPi on Raspberry Pi (tested on 3B)
- Display (HDMI) and network

---

## Publish this project to GitHub (from your PC)

From the project folder on your machine:

```bash
cd /home/eymardfreire/worldmonitor-kiosk

git init
git add README.md install.sh custom.sh install-on-pi.sh .gitignore
git commit -m "World Monitor kiosk for DietPi"
```

Create a new repo on GitHub (e.g. `worldmonitor-kiosk`), then:

```bash
git remote add origin https://github.com/YOUR_USERNAME/worldmonitor-kiosk.git
git branch -M main
git push -u origin main
```

Use the same `YOUR_USERNAME` in the one-line install on the Pi.

---

## Changing the World Monitor URL

On the Pi:

```bash
sudo nano /var/lib/dietpi/dietpi-autostart/custom.sh
```

Edit the `URL=` line, save, then `sudo reboot`.

Default URL:

```
https://worldmonitor.app/?lat=20.0000&lon=0.0000&zoom=1.00&view=global&timeRange=7d&layers=conflicts%2Cbases%2Chotspots%2Cnuclear%2Csanctions%2Cweather%2Ceconomic%2Cwaterways%2Cnatural
```

---

## Troubleshooting

| Issue | What to try |
|-------|-------------|
| Black screen | `journalctl -u dietpi-autostart_custom`; ensure Chromium is installed (`which chromium-browser` or `which chromium`). |
| "Missing X server or $DISPLAY" | **Quick fix:** use DietPi's built-in Chromium kiosk instead: `dietpi-autostart` → choose **11** (Chromium - Dedicated use without desktop) → when asked for URL, paste the World Monitor URL (see "Changing the World Monitor URL" below) → reboot. Or install xinit: `apt-get update && apt-get install -y xinit`, then re-run the one-line install and reboot. |
| Chromium not found | Install: `dietpi-software install 113` |
| Freezes (Pi 3B) | Enable swap: `dietpi-config` → Swap file → 1024 MB |
| Wrong resolution | `dietpi-config` → Display Options, or `/boot/firmware/config.txt` (or `/boot/config.txt`) |
| Exit kiosk | `Alt+F4` or `Ctrl+W`; you’ll get a console login. |

---

## References

- [World Monitor](https://worldmonitor.app)
- [DietPi autostart (Chromium / Custom)](https://dietpi.com/forum/t/chromium-autostart-command-line/1227)
- DietPi custom script: `/var/lib/dietpi/dietpi-autostart/custom.sh`  
- DietPi autostart index **17** = Custom script (foreground, with autologin)
