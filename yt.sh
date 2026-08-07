#!/usr/bin/env bash

subscribed=$HOME/.local/share/ytfzf/subscribed.txt
mkdir -p "$HOME/.local/share/ytfzf"

sub () {
  [ -f "$subscribed" ] || notify-send "Creating $subscribed"
  touch "$subscribed"

  csub=$(cat "$subscribed" | dmenu -fn 'FireCode-14' -nb '#282a36' -sf '#ad90ff' -sb '#44475a' -nf '#bd93f9' -l 20 -i -p "Choose subscription or create new:")
  if [[ "$csub" == "" ]]; then
    exit 0
  fi
  grep -Fxq "$csub" "$subscribed" || echo "$csub" >>"$subscribed"

  setsid -f "${TERMINAL:-st}" -c "floating" -e ytfzf -T chafa -t -e --query "$csub" 2>/dev/null
}

rec () {
  [ -f "$subscribed" ] || notify-send "Don't have subscriptions for recs" | exit 1
}

choice=$(echo -e "sub\nrec" | dmenu -fn 'FireCode-14' -nb '#282a36' -sf '#ad90ff' -sb '#44475a' -nf '#bd93f9' -i -p "Seach for video:")

case "$choice" in
  sub) sub ;;
  rec) rec ;;
  *) setsid -f "${TERMINAL:-st}" -c "floating" -e ytfzf -T chafa -t -e --query "$choice" 2>/dev/null ;;
esac
