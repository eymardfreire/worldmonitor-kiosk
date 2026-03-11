#!/bin/bash
# World Monitor Kiosk - one-line install for DietPi (Raspberry Pi)
# Usage (from a fresh DietPi, no args needed):
#   curl -sL https://raw.githubusercontent.com/eymardfreire/worldmonitor-kiosk/main/install.sh | sudo bash
# Or with a different repo: ... | sudo bash -s USER/repo-name

set -e
REPO="${1:-eymardfreire/worldmonitor-kiosk}"
BRANCH="${2:-main}"
BASE="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
TARGET="/var/lib/dietpi/dietpi-autostart/custom.sh"

echo "=== World Monitor Kiosk for DietPi ==="
echo "Repo: $REPO"
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

# 2b. Install xinit so custom script can start X (needed for option 17)
if ! command -v xinit >/dev/null 2>&1; then
  echo "Installing xinit for display..."
  apt-get update -qq && apt-get install -y xinit 2>/dev/null || true
fi

# 3. Download and install kiosk script
mkdir -p "$(dirname "$TARGET")"
echo "Downloading kiosk script..."
if ! curl -sLf "${BASE}/custom.sh" -o "$TARGET"; then
  echo "Error: Could not download custom.sh from ${BASE}/custom.sh"
  echo "Check REPO (e.g. username/worldmonitor-kiosk) and branch (default: main)."
  exit 1
fi
chmod +x "$TARGET"
echo "Installed to $TARGET"

# 4. Set autostart to Custom (foreground + autologin)
# DietPi index 17 = Custom script (foreground, with autologin)
echo "Setting autostart to Custom kiosk..."
if command -v dietpi-autostart >/dev/null 2>&1; then
  dietpi-autostart 17 2>/dev/null || {
    echo "Could not set autostart automatically. Run: dietpi-autostart"
    echo "  -> Select '17' / 'Custom script (foreground, with autologin)'"
  }
else
  echo "Run: dietpi-autostart -> Select 'Custom script (foreground, with autologin)'"
fi

echo ""
echo "=== Done. Reboot to start World Monitor kiosk: sudo reboot"
echo "(On Pi 3B with 1GB RAM, enable swap in dietpi-config for stability.)"
echo ""
