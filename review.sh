#!/bin/bash

source config.sh

ask() {
  while true; do
    read -e -r -p "$1 (Y/n): " response
    response=${response,,}
    [[ -z "$response" || "$response" == "y" || "$response" == "n" ]] && break
  done

    [[ -z "$response" || "$response" == "y" ]] && return 0
    [[ "$response" == "n" ]] && return 0
}

# TODO: Skip records which are in TOP BOX

[ -e "$DECK_PATH" ] || touch "$DECK_PATH"

ready_to_review=""

while IFS= read -r card; do
  IFS="|" read -r _box date _front _back  <<< "$card"

  if (( $(date -d "$date" +%s) < $(date +%s) )); then
    ready_to_review+="$card"$'\n'
  fi
done < "$DECK_PATH"

# TODO: Fix this IFS reassigning
IFS=$'\n'
for card in $ready_to_review; do
  IFS="|" read -r box date front back  <<< "$card"

  echo -e "\n  [ $front ]\n"
  read -r -p "Hit return to show back side"
  echo -e "\033[4A\n  [ $front ] [ $back ]\n"

  updated_box=$(ask "Did you remember it?" && echo $((box + 1)) || echo 0)
  updated_date_seconds=$(($(date +%s) + INTERVALS[updated_box]))
  updated_date=$(date -d "@$updated_date_seconds" +"%Y-%m-%d %H:%M:%S")
  updated_card="$updated_box|$updated_date|$front|$back"
  sed -i "s/${card}/${updated_card}/g" "$DECK_PATH"

  echo -e "\033[3A"
  IFS=$'\n'
done
