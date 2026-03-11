#!/bin/bash
# World Monitor Kiosk - one-line install for DietPi (Raspberry Pi)
# Uses DietPi option 11 (Chromium kiosk) and sets the World Monitor URL automatically.
# Usage: curl -sL https://raw.githubusercontent.com/eymardfreire/worldmonitor-kiosk/main/install.sh | sudo bash

set -e
DIETPI_TXT="/boot/dietpi.txt"
# Same URL as in custom.sh (global view, 7d, layers)
WORLDMONITOR_URL='https://worldmonitor.app/?lat=20.0000&lon=0.0000&zoom=1.00&view=global&timeRange=7d&layers=conflicts%2Cbases%2Chotspots%2Cnuclear%2Csanctions%2Cweather%2Ceconomic%2Cwaterways%2Cnatural'

echo "=== World Monitor Kiosk for DietPi ==="
echo ""

# 1. Ensure we're on DietPi
if [ ! -d /var/lib/dietpi ]; then
  echo "Error: DietPi not detected (/var/lib/dietpi missing). Run this on a DietPi system."
  exit 1
fi

# 2. Install Chromium if missing
if ! command -v chromium-browser >/dev/null 2>&1 && ! command -v chromium >/dev/null 2>&1; then
  echo "Chromium not found. Installing (dietpi-software install 113)..."
  dietpi-software install 113
else
  echo "Chromium already installed."
fi

# 3. Set World Monitor URL and autologin user in dietpi.txt
echo "Setting World Monitor URL and autologin in $DIETPI_TXT..."
if [ -f "$DIETPI_TXT" ]; then
  if grep -q '^[[:space:]]*SOFTWARE_CHROMIUM_AUTOSTART_URL=' "$DIETPI_TXT" 2>/dev/null; then
    URL_ESC="${WORLDMONITOR_URL//&/\\&}"
    sed -i "s|^[[:space:]]*SOFTWARE_CHROMIUM_AUTOSTART_URL=.*|SOFTWARE_CHROMIUM_AUTOSTART_URL=$URL_ESC|" "$DIETPI_TXT"
  else
    echo "SOFTWARE_CHROMIUM_AUTOSTART_URL=$WORLDMONITOR_URL" >> "$DIETPI_TXT"
  fi
  # Ensure autologin user is set (required for option 11 to auto-start)
  if ! grep -q '^[[:space:]]*AUTO_SETUP_AUTOSTART_LOGIN_USER=' "$DIETPI_TXT" 2>/dev/null; then
    echo "AUTO_SETUP_AUTOSTART_LOGIN_USER=root" >> "$DIETPI_TXT"
  fi
  echo "URL and autologin user set."
else
  echo "Warning: $DIETPI_TXT not found."
fi

# 4. Persist autostart index 11 and run DietPi's apply (sets up getty autologin etc.)
AUTOSTART_INDEX="/boot/dietpi/.dietpi-autostart_index"
mkdir -p "$(dirname "$AUTOSTART_INDEX")" 2>/dev/null || true
if [ -d "$(dirname "$AUTOSTART_INDEX")" ]; then
  echo 11 > "$AUTOSTART_INDEX"
  echo "Autostart index 11 (Chromium kiosk) written."
fi

echo "Applying autostart (option 11)..."
if command -v dietpi-autostart >/dev/null 2>&1; then
  dietpi-autostart 11 || {
    echo ""
    echo ">>> If the kiosk does not start after reboot, run this once (from the Pi console or SSH):"
    echo "    dietpi-autostart"
    echo "    -> Select 11 (Chromium - Dedicated use without desktop), confirm URL, then reboot."
    echo ""
  }
else
  echo "Run: dietpi-autostart -> Select '11' (Chromium kiosk)"
fi

echo ""
echo "=== Done. Reboot: sudo reboot"
echo "If you still get a login prompt after reboot, run 'dietpi-autostart', choose 11, confirm the URL, then reboot again."
echo "(On Pi 3B with 1GB RAM, enable swap in dietpi-config for stability.)"
echo ""
