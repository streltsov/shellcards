#!/bin/bash

source config.sh

while true; do
read -e -r -p "Front: " front
  read -e -r -p "Back: " back
  
  record="0"
  record+=$DELIMETER
  # TODO: Add first interval
  record+=$(date +"%Y-%m-%d %H:%M:%S")
  record+=$DELIMETER
  record+=$front
  record+=$DELIMETER
  record+=$back
  
  DECK_DIR_PATH=$(dirname "$DECK_PATH")
  [ -d "$DECK_DIR_PATH" ] || mkdir -p "$DECK_DIR_PATH"
  [ -e "$DECK_PATH" ] || touch "$DECK_PATH"
  
  echo "$record" >> "$DECK_PATH"
done
