#!/bin/bash
set -euo pipefail
source config.sh

ask() {
  while true; do
    read -e -r -p "$1 (Y/n): " response </dev/tty
    response=${response,,}
    [[ -z "$response" || "$response" == "y" || "$response" == "n" ]] && break
  done

  [[ -z "$response" || "$response" == "y" ]] && return 0 || return 1
}

ready_to_review=""

while IFS= read -r card; do
  IFS="|" read -r box date _front _back <<<"$card"
  [[ "$box" == "${#INTERVALS[@]}" ]] && continue
  [[ $(date -d "$date" +%s) -lt $(date +%s) ]] && ready_to_review+="$card"$'\n'
done <"$DECK_PATH"

echo "$ready_to_review" | while IFS= read -r card; do
  IFS="|" read -r box date front back <<<"$card"

  echo -e "\n  [ $front ]\n"
  read -r -p "Hit return to show back side" </dev/tty
  echo -e "\033[4A\n  [ $front ] [ $back ]\n"

  updated_box=$(ask "Did you remember it?" && echo $((box + 1)) || echo 0)
  updated_date_seconds=$(($(date +%s) + INTERVALS[updated_box]))
  updated_date=$(date -d "@$updated_date_seconds" +"%Y-%m-%d %H:%M:%S")
  updated_card="$updated_box$DELIMETER$updated_date$DELIMETER$front$DELIMETER$back"
  sed -i "s/${card}/${updated_card}/g" "$DECK_PATH"

  echo -e "\033[3A"
done
