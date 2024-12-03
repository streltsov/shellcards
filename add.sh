#!/bin/bash

source config.sh

read -e -r -p "Front: " front
read -e -r -p "Back: " back

record="0"
record+=$DELIMETER
record+=$(date +"%Y-%m-%d %H:%M:%S")
record+=$DELIMETER
record+=$front
record+=$DELIMETER
record+=$back

[ -e "$DECK_PATH" ] || touch "$DECK_PATH"

echo "$record" >> "$DECK_PATH"
