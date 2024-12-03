#!/bin/bash

deck_file="/home/streltsov/shared-2/.deck.csv"
INTERVALS=(120 600 3600 18000 86400 432000 1036800 2160000 10368000)


ready_to_review=""

# Find cards ready to review
while IFS= read -r record; do
  IFS="|" read -r _type _box date _front _back  <<< "$record"
  review_date_seconds=$(date -d "$date" +%s 2>/dev/null)
  current_date_seconds=$(date +%s)

  if (( review_date_seconds < current_date_seconds )); then
    ready_to_review+="$record"
    ready_to_review+=$'\n'
  fi
done < "$deck_file"

# TODO: Fix this IFS reassigning
IFS=$'\n'
for record in $ready_to_review; do
  IFS="|" read -r type box date front back  <<< "$record"

  if [ "$type" == basic ]; then
    echo "$front"

    while true; do
      read -r -e -p "Do you remember this word(y/n)?" answer

      if [ "$answer" == y ]; then
        updated_box=$((box + 1))
        _current_date_seconds=$(date +%s)
        updated_date_seconds=$((_current_date_seconds + INTERVALS[updated_box]))
        updated_date=$(date -d "@$updated_date_seconds" +"%Y-%m-%d %H:%M:%S")
        updated_record="$type|$updated_box|$updated_date|$front|$back"
        sed -i "s/${record}/${updated_record}/g" "$deck_file"
        echo "$back"
        break
      fi

      if [ "$answer" == n ]; then
        updated_box=0
        _current_date_seconds=$(date +%s)
        updated_date_seconds=$((_current_date_seconds + INTERVALS[updated_box]))
        updated_date=$(date -d "@$updated_date_seconds" +"%Y-%m-%d %H:%M:%S")
        updated_record="$type|$updated_box|$updated_date|$front|$back"
        sed -i "s/${record}/${updated_record}/g" "$deck_file"
        echo "$back"
        break
      fi
    done


    while true; do
      read -r -e -p "Proceed? (y)" answer
      if [ y == "$answer" ]; then
        break
      fi
    done
  fi
IFS=$'\n'
done
