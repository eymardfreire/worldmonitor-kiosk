#!/bin/bash
# World Monitor kiosk - DietPi custom autostart
# Copy to: /var/lib/dietpi/dietpi-autostart/custom.sh
# Then: dietpi-autostart -> choose "Custom (foreground, with autologin)"

# Your World Monitor URL (edit to change view/zoom/layers)
URL='https://worldmonitor.app/?lat=20.0000&lon=0.0000&zoom=1.00&view=global&timeRange=7d&layers=conflicts%2Cbases%2Chotspots%2Cnuclear%2Csanctions%2Cweather%2Ceconomic%2Cwaterways%2Cnatural'

# Prefer chromium-browser (Debian/Raspberry Pi OS), fallback to chromium
for cmd in chromium-browser chromium; do
  if command -v "$cmd" >/dev/null 2>&1; then
    CHROMIUM="$cmd"
    break
  fi
done

if [ -z "$CHROMIUM" ]; then
  echo "World Monitor kiosk: Chromium not found. Install with: dietpi-software install 113"
  exit 1
fi

# Kiosk + Pi-friendly flags (single tab, no dialogs, reduce memory use)
exec "$CHROMIUM" \
  --bwsi \
  --disable-breakpad \
  --kiosk \
  --noerrdialogs \
  --disable-infobars \
  --disable-session-crashed-bubble \
  --disable-restore-session-state \
  --no-first-run \
  --disable-translate \
  --incognito \
  --disable-dev-shm-usage \
  --no-sandbox \
  "$URL"
