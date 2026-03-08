#!/bin/bash
# World Monitor kiosk - DietPi custom autostart
# Runs in console; starts X then Chromium (option 17 has no display by default).

URL='https://worldmonitor.app/?lat=20.0000&lon=0.0000&zoom=1.00&view=global&timeRange=7d&layers=conflicts%2Cbases%2Chotspots%2Cnuclear%2Csanctions%2Cweather%2Ceconomic%2Cwaterways%2Cnatural'

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

if ! command -v xinit >/dev/null 2>&1; then
  echo "World Monitor kiosk: xinit not found. Install with: apt-get install -y xinit"
  exit 1
fi

# Wrapper so xinit can run Chromium with all args (xinit runs one client command)
WRAPPER="/tmp/worldmonitor-chromium-$$.sh"
trap "rm -f $WRAPPER" EXIT
cat << EOF > "$WRAPPER"
#!/bin/bash
exec $CHROMIUM \\
  --bwsi \\
  --disable-breakpad \\
  --kiosk \\
  --noerrdialogs \\
  --disable-infobars \\
  --disable-session-crashed-bubble \\
  --disable-restore-session-state \\
  --no-first-run \\
  --disable-translate \\
  --incognito \\
  --disable-dev-shm-usage \\
  --no-sandbox \\
  "$URL"
EOF
chmod +x "$WRAPPER"

# Start X server (:0) with Chromium as the only client
exec xinit "$WRAPPER" -- :0
