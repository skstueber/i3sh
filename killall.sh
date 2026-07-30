#!/usr/bin/env bash
# Modified from https://github.com/BreadOnPenguins/scripts/blob/master/shortcuts-menus/sys

ps -u "$USER" -o pid,comm,%cpu,%mem | dmenu -fn 'FireCode-14' -nb '#282a36' -sf '#f4800d' -sb '#44475a' -nf '#bd93f9' -l 10 -i -p KILLALL: | awk '{print $2}' | xargs -r killall
