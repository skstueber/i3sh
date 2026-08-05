#!/usr/bin/env bash

var=($(pactl list short sinks | cut -f2))

sink=$(pactl get-default-sink | cut -f1)

if [[ "${var[0]}" == "$sink" ]]; then
    pactl set-default-sink "${var[1]}"
else
    pactl set-default-sink "${var[0]}"
fi

