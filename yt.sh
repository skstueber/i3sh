#!/usr/bin/env bash

choice=$(echo "sidemen" | dmenu -fn 'FireCode-14' -nb '#282a36' -sf '#ad90ff' -sb '#44475a' -nf '#bd93f9' -p "Search for video: ")

ytfzf -e "$choice"
