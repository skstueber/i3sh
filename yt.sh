#!/usr/bin/env bash

subscribed=$HOME/.local/share/ytfzf/subscribed.txt
mkdir -p "$HOME/.local/share/ytfzf"

all () {
  setsid -f "${TERMINAL:-st}" -c "floating" -e ytfzf -T chafa -t --sort --sort-by=relevance --query "All" 2>/dev/null
}

sub () {
  csub=$(echo -e "All\n$(cat "$subscribed")" | dmenu -fn 'FireCode-14' -nb '#282a36' -sf '#ad90ff' -sb '#44475a' -nf '#bd93f9' -l 20 -i -p "Choose subscription or create new:")
  if [[ "$csub" == "" ]]; then
    exit 0
  fi
  if [[ "$csub" == "All" ]] && [[ ! -f "$subscribed" ]]; then
    notify-send "No subscriptions found" | exit 1
  fi

  [ -f "$subscribed" ] || notify-send "Creating $subscribed"
  touch "$subscribed"

  grep -Fxq "$csub" "$subscribed" || echo "$csub" >>"$subscribed"

  setsid -f "${TERMINAL:-st}" -c "floating" -e ytfzf -T chafa -t --sort --sort-by=relevance --query "$csub" 2>/dev/null
}

rec () {
  [ -f "$subscribed" ] || notify-send "Don't have subscriptions for recs" | exit 1
}

choice=$(echo -e "sub\nrec\nhist" | dmenu -fn 'FireCode-14' -nb '#282a36' -sf '#ad90ff' -sb '#44475a' -nf '#bd93f9' -i -p "Seach for video:")

case "$choice" in
  sub) sub ;;
  rec) rec ;;
  hist) ;;
  "") exit 0 ;;
  *) setsid -f "${TERMINAL:-st}" -c "floating" -e ytfzf -T chafa -t --detach --query "$choice" 2>/dev/null ;;
esac
