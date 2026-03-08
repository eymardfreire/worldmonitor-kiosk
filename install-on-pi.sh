#!/bin/bash
# Run this script ON THE RASPBERRY PI (DietPi) from the folder that contains custom.sh
# Example: ./install-on-pi.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="/var/lib/dietpi/dietpi-autostart/custom.sh"

if [ ! -f "$SCRIPT_DIR/custom.sh" ]; then
  echo "Error: custom.sh not found in $SCRIPT_DIR"
  exit 1
fi

echo "Installing World Monitor kiosk script to $TARGET"
sudo cp "$SCRIPT_DIR/custom.sh" "$TARGET"
sudo chmod +x "$TARGET"
echo "Done. Now run: dietpi-autostart"
echo "  -> Select 'Custom' (Custom script, foreground, with autologin)"
echo "  -> Reboot to start the kiosk: sudo reboot"
