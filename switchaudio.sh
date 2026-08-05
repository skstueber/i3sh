#!/usr/bin/env bash
# Switch audio output between two devices
# If bluetooth is active, disconnect and power off
# Then system will default to headphones if connected or monitor if not
# Run again if switch to monitor is desired with headphones connected
# If bluetooth is not active, switch between headphones and monitor (or whatever is 2 devices are connected)

if systemctl is-active --quiet bluetooth.service && bluetoothctl show | grep -q '^[[:space:]]*Powered: yes$'; then
  mac=$(bluetoothctl devices Connected | awk 'NR == 1 {print $2}')

  if [[ -n $mac ]]; then
    bluetoothctl disconnect "$mac"
    bluetoothctl power off
    exit 0
  fi
  bluetoothctl power off
fi

var=($(pactl list short sinks | cut -f2))

if ((${#var[@]} < 2)); then
  notify-send "Not enough audio devices"
  exit 1
fi

if ((${#var[@]} > 2)); then
  notify-send "Too many audio devices"
  exit 1
fi

current=$(pactl get-default-sink)

if [[ "${var[0]}" == "$current" ]]; then
  pactl set-default-sink "${var[1]}"
else
  pactl set-default-sink "${var[0]}"
fi
