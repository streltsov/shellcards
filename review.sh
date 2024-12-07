#!/bin/bash
set -euo pipefail
source config.sh

# TODO: use tab as delimeter (and remove it from config maybe)
# TODO: make script readable instead of scarce
# TODO: Feature: if the answer is not "", "y" or "n", compare string with the
# opposite side of the box
# TODO: Feature: reverse cards

ask() {
	while true; do
		read -e -r -p "$1 (Y/n): " response </dev/tty
		response=${response,,}
		[[ -z "$response" || "$response" == "y" || "$response" == "n" ]] && break
	done

	[[ -z "$response" || "$response" == "y" ]] && return 0 || return 1
}

# due_for_review=""
#
# # TODO: Use awk instead
# while IFS= read -r card; do
# 	IFS="|" read -r box date _front _back <<<"$card"
# 	[[ "$box" == "${#INTERVALS[@]}" ]] && continue
# 	[[ $(date -d "$date" +%s) -lt $(date +%s) ]] && due_for_review+="$card"$'\n'
# done <"$DECK_PATH"

# awk -v curr="$current_date" '$1 < curr && $2 < 10' data.txt
echo "$due_for_review" | shuf | while IFS= read -r card; do
	IFS="|" read -r box date front back <<<"$card"

	echo -e "\n  [ $front ]\n"
	read -r -p "Hit return to show back side" </dev/tty
	echo -e "\033[4A\n  [ $front ] [ $back ]\n"

	updated_box=$(ask "Did you remember it?" && echo $((box + 1)) || echo 0)
	updated_date_seconds=$(($(date +%s) + INTERVALS[updated_box]))
	updated_date=$(date -d "@$updated_date_seconds" "$DATE_FORMAT")
	updated_card="$updated_box$DELIMETER$updated_date$DELIMETER$front$DELIMETER$back"
	sed -i "s/${card}/${updated_card}/g" "$DECK_PATH"

	echo -e "\033[3A"
done
