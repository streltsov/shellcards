#!/bin/bash

source config.sh
# TODO: Skip records which are in TOP BOX
# TODO: Rename record to card
# TODO: Polish texts

[ -e "$DECK_PATH" ] || touch "$DECK_PATH"

ready_to_review=""

# Find cards ready to review
while IFS= read -r record; do
  IFS="|" read -r _box date _front _back  <<< "$record"
  review_date_seconds=$(date -d "$date" +%s 2>/dev/null)
  current_date_seconds=$(date +%s)

  if (( review_date_seconds < current_date_seconds )); then
    ready_to_review+="$record"
    ready_to_review+=$'\n'
  fi
done < "$DECK_PATH"

# TODO: Fix this IFS reassigning
IFS=$'\n'
for record in $ready_to_review; do
  IFS="|" read -r box date front back  <<< "$record"

    echo "$front"

    while true; do
      read -r -e -p "Do you remember this word(y/n)?" answer

      if [ "$answer" == y ]; then
        updated_box=$((box + 1))
        _current_date_seconds=$(date +%s)
        updated_date_seconds=$((_current_date_seconds + INTERVALS[updated_box]))
        updated_date=$(date -d "@$updated_date_seconds" +"%Y-%m-%d %H:%M:%S")
        updated_record="$updated_box|$updated_date|$front|$back"
        sed -i "s/${record}/${updated_record}/g" "$DECK_PATH"
        echo "$back"
        break
      fi

      if [ "$answer" == n ]; then
        updated_box=0
        _current_date_seconds=$(date +%s)
        updated_date_seconds=$((_current_date_seconds + INTERVALS[updated_box]))
        updated_date=$(date -d "@$updated_date_seconds" +"%Y-%m-%d %H:%M:%S")
        updated_record="$updated_box|$updated_date|$front|$back"
        sed -i "s/${record}/${updated_record}/g" "$DECK_PATH"
        echo "$back"
        break
      fi
    done


    # TODO: Proceed with enter
    while true; do
      read -r -e -p "Proceed? (Y)" answer
      if [ y == "$answer" ]; then
        break
      fi
    done
IFS=$'\n'
done
