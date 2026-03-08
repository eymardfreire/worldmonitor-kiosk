# World Monitor Kiosk for DietPi (Raspberry Pi)

Boot your Pi straight into [World Monitor](https://worldmonitor.app) in full-screen—no desktop, no LXDE. Just power on → World Monitor.

## One-line install (on the Pi)

After you push this repo to GitHub, on your **Raspberry Pi (DietPi)** run (replace `YOUR_USERNAME` with your GitHub username):

```bash
curl -sL https://raw.githubusercontent.com/YOUR_USERNAME/worldmonitor-kiosk/main/install.sh | sudo bash
```

Or with repo as argument (so the script knows where to fetch files from):

```bash
curl -sL https://raw.githubusercontent.com/YOUR_USERNAME/worldmonitor-kiosk/main/install.sh | sudo bash -s YOUR_USERNAME/worldmonitor-kiosk
```

The script will:

1. Install Chromium if missing
2. Download and install the kiosk script
3. **Remove LXDE** (ID 23) so the Pi doesn’t load a desktop—only the kiosk
4. Set DietPi autostart to **Custom (foreground, with autologin)** so the kiosk runs after boot

Then **enable swap** on Pi 3B (1 GB RAM) and **reboot**:

```bash
dietpi-config
# → Swap file → enable, 1024 MB

sudo reboot
```

After reboot, the Pi should show World Monitor in full screen.

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
| "Missing X server or $DISPLAY" | Install xinit: `apt-get update && apt-get install -y xinit`, then reboot. |
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
