#!/usr/bin/env bash
# Modified from https://github.com/BreadOnPenguins/scripts/blob/master/shortcuts-menus/notes

folder="$HOME/ideas/"

# Ensure the base notes directory exists
mkdir -p "$folder"

newnote() {
  dir="$(command ls -d "$folder" "$folder"*/ | dmenu -fn 'FireCode-14' -nb '#282a36' -sf '#ad90ff' -sb '#44475a' -nf '#bd93f9' -i -p 'Choose directory: ')" || exit 0
  : "${dir:=$folder}"

  name="$(
    echo "" | dmenu -fn 'FireCode-14' -nb '#282a36' -sf '#ad90ff' -sb '#44475a' -nf '#bd93f9' -p "Enter a name: " <&-
  )" || exit 0
  : "${name:=$(date +%F_%H-%M-%S)}"

  full_path="${dir%/}/${name}.md"

  setsid -f "${TERMINAL:-st}" -c "floating" -f "Liberation Mono:size=13" -e nvim "$full_path" >/dev/null 2>&1
}

default() {
  full_path="${folder%/}/$1.md"

  setsid -f "${TERMINAL:-st}" -c "floating" -f "Liberation Mono:size=13" -e nvim "$full_path" >/dev/null 2>&1
}

selected() {
  # Format list cleanly relative to the folder root
  choice=$(
    echo -e "Dir\n$(find "$folder" -type f -name "*.md" -printf '%T@ %P\n' | sort -nr | cut -d' ' -f2-)" | dmenu -fn 'FireCode-14' -nb '#282a36' -sf '#ad90ff' -sb '#44475a' -nf '#bd93f9' -i -p "Choose note or create new: "
  )

  case "$choice" in
  "") exit 0 ;;
  Dir) newnote ;;
  *.md) setsid -f "${TERMINAL:-st}" -c "floating" -f "Liberation Mono:size=13" -e nvim "$folder$choice" >/dev/null 2>&1 ;;
  *) default "$choice" ;;
  esac
}

selected
