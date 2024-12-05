#!/bin/bash

set -euo pipefail
source config.sh
DATE_FORMAT="+%Y-%m-%d %H:%M:%S"

while true; do
  read -e -r -p "Front: " front
  read -e -r -p "Back: " back

  box=0
  seconds=$(($(date +%s) + ${INTERVALS[box]}))
  date=$(date -d "@$seconds" "$DATE_FORMAT")
  record="0$DELIMETER$date$DELIMETER$front$DELIMETER$back"

  DECK_DIR_PATH=$(dirname "$DECK_PATH")
  [ -d "$DECK_DIR_PATH" ] || mkdir -p "$DECK_DIR_PATH"
  [ -e "$DECK_PATH" ] || touch "$DECK_PATH"

  echo "$record" >>"$DECK_PATH"
done
