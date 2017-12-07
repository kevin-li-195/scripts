#!/bin/sh
CURR_POWER=$(cat /sys/class/power_supply/BAT0/charge_now)
MAX_POWER=$(cat /sys/class/power_supply/BAT0/charge_full)
PERCENT=$(echo "scale = 2; 100 * $CURR_POWER / $MAX_POWER" | bc)
echo "Current battery level: $PERCENT%"
