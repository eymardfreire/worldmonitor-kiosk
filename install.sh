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

# 3. Set World Monitor URL for Chromium kiosk (option 11 reads this from dietpi.txt)
echo "Setting World Monitor URL in $DIETPI_TXT..."
if [ -f "$DIETPI_TXT" ]; then
  if grep -q '^[[:space:]]*SOFTWARE_CHROMIUM_AUTOSTART_URL=' "$DIETPI_TXT" 2>/dev/null; then
    # Escape & for sed replacement
    URL_ESC="${WORLDMONITOR_URL//&/\\&}"
    sed -i "s|^[[:space:]]*SOFTWARE_CHROMIUM_AUTOSTART_URL=.*|SOFTWARE_CHROMIUM_AUTOSTART_URL=$URL_ESC|" "$DIETPI_TXT"
  else
    echo "SOFTWARE_CHROMIUM_AUTOSTART_URL=$WORLDMONITOR_URL" >> "$DIETPI_TXT"
  fi
  echo "URL set."
else
  echo "Warning: $DIETPI_TXT not found. After install, run dietpi-autostart, choose 11, and paste the URL when asked."
fi

# 4. Set autostart to option 11 (Chromium - dedicated use without desktop)
echo "Setting autostart to Chromium kiosk (option 11)..."
if command -v dietpi-autostart >/dev/null 2>&1; then
  dietpi-autostart 11 2>/dev/null || {
    echo "Could not set autostart automatically. Run: dietpi-autostart"
    echo "  -> Select '11' (Chromium - Dedicated use without desktop)"
  }
else
  echo "Run: dietpi-autostart -> Select '11' (Chromium kiosk)"
fi

echo ""
echo "=== Done. Reboot to start World Monitor kiosk: sudo reboot"
echo "(On Pi 3B with 1GB RAM, enable swap in dietpi-config for stability.)"
echo ""
