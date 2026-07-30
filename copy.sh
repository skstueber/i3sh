#!/usr/bin/env bash
# Modified from https://github.com/BreadOnPenguins/scripts/blob/master/shortcuts-menus/txtcliphist
# PUT IN /usr/bin/ for full functionality

histfile="$HOME/.cache/cliphist"
placeholder="<NEWLINE>"

highlight() {
  clip=$(xclip -o -selection primary | xclip -i -f -selection clipboard 2>/dev/null)
}

output() {
  clip=$(xclip -i -f -selection clipboard 2>/dev/null)
}

write() {
  [ -f "$histfile" ] || notify-send -a "FILE" "Creating $histfile"
  touch $histfile
  [ -z "$clip" ] && exit 0
  multiline=$(echo "$clip" | sed ':a;N;$!ba;s/\n/'"$placeholder"'/g')
  grep -Fxq "$multiline" "$histfile" || echo "$multiline" >>"$histfile"
}

sel() {
  selection=$(tac "$histfile" | dmenu -b -l 5 -i -p "Clipboard history:")
  [ -n "$selection" ] && echo "$selection" | sed "s/$placeholder/\n/g" | xclip -i -selection clipboard && notification="Copied to clipboard!"
}

clear() {
  rm -rf "$histfile" || notify-send -a "CLIPBOARD" "Cleared"
}

help() {
  printf "Usage: copy [COMMANDS]\n"
  printf "\n"
  printf "COMMANDS:\n"
  printf "  add: add current selection to history\n"
  printf "  out: output current selection to clipboard\n"
  printf "  sel: select from history\n"
  printf "  clear: clear history\n"
  printf "  help: show this help\n"
  exit 0
}

if [ -f "$histfile" ] && [ "$1" != "sel" ] && [ "$1" != "clear" ] && [ "$(wc -l <"$histfile")" -gt 9 ]; then
  sed -i '1d' "$histfile"
fi

case "$1" in
add) highlight && write ;;
out) output && write ;;
sel) sel ;;
clear) clear ;;
help) help ;;
*)
  help ;;
esac
