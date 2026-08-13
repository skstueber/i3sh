#!/usr/bin/env bash
# Modified from https://github.com/BreadOnPenguins/scripts/blob/master/shortcuts-menus/notes

folder="$HOME/ideas/"
dirs="$HOME/.cache/notehist/dirs"
notes="$HOME/.cache/notehist/notes"

# Ensure the base notes directory exists
mkdir -p "$folder"

newdir() {
  dir=$(dmenu -fn "FireCode-14" -nb "#282a36" -sf "#ad90ff" -sb "#44475a" -nf "#bd93f9" -i -p "Choose directory or create new:" < "$dirs") || exit 0

  if [[ "${dir:0:1}" == "/" ]]; then
    dir="${dir:1}"
    echo "$dir" >>"$dirs"
  elif grep -Fxq -- "$dir" "$dirs"; then
    dir="$HOME/$dir"
  else
    dir="$folder$dir"
  fi

  mkdir -p "$dir"

  name="$(
    echo "" | dmenu -fn 'FireCode-14' -nb '#282a36' -sf '#ad90ff' -sb '#44475a' -nf '#bd93f9' -p "Enter a name: " <&-
  )" || exit 0
  : "${name:=$(date +%F_%H-%M-%S)}"

  [[ "$name" == *.md ]] || name="$name.md"
  full_path="${dir%/}/$name"

  echo "$full_path" >>"$notes"

  setsid -f "${TERMINAL:-st}" -c "floating" -f "Liberation Mono:size=13" -e nvim "$full_path" >/dev/null 2>&1
}

selected() {
  choice=$(
    {
      echo "Dir"
      cat "$notes"
      find "$folder" -type f -name "*.md" -printf '%T@ %P\n' |
        sort -nr |
        cut -d' ' -f2-
    } | dmenu -fn 'FireCode-14' -nb '#282a36' -sf '#ad90ff' -sb '#44475a' -nf '#bd93f9' -i -p "Choose note or create new: "
  )

  case "$choice" in
  "") exit 0 ;;
  Dir) newdir ;;
  */*)
    # If the file exists in ideas/, open it there; otherwise it is a custom dir
    if [[ -f "$folder$choice" ]]; then
      setsid -f "${TERMINAL:-st}" -c "floating" -f "Liberation Mono:size=13" -e nvim "$folder$choice" >/dev/null 2>&1
    else
      setsid -f "${TERMINAL:-st}" -c "floating" -f "Liberation Mono:size=13" -e nvim "$choice" >/dev/null 2>&1
    fi
    ;;
  *.md) setsid -f "${TERMINAL:-st}" -c "floating" -f "Liberation Mono:size=13" -e nvim "$folder$choice" >/dev/null 2>&1 ;;
  *) setsid -f "${TERMINAL:-st}" -c "floating" -f "Liberation Mono:size=13" -e nvim "$folder$choice.md" >/dev/null 2>&1 ;;
  esac
}

selected
