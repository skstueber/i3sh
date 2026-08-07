#!/usr/bin/env bash

subscribed=~/.local/share/ytfzf/subscribed.txt

mkdir -p ~/.local/share/ytfzf

sub () {
  [ -f "$subscribed" ] || notify-send "Creating $subscribed"
  touch "$subscribed"

  csub=$(cat $subscribed | dmenu -fn 'FireCode-14' -nb '#282a36' -sf '#ad90ff' -sb '#44475a' -nf '#bd93f9' -l 20 -i -p "Choose subscription or create new:")
}

rec () {
  setsid -f "${TERMINAL:-st}" -c "floating" -e ytfzf -T chafa -t -e --query "$choice" 2>/dev/null
}

choice=$(echo -e "sub\nrec $(cat $subscribed)" | dmenu -fn 'FireCode-14' -nb '#282a36' -sf '#ad90ff' -sb '#44475a' -nf '#bd93f9' -i -p "Seach for video:")

case "$choice" in
  sub) sub ;;
  rec) rec ;;
  *) setsid -f "${TERMINAL:-st}" -c "floating" -e ytfzf -T chafa -t -e --query "$choice" 2>/dev/null ;;
esac
