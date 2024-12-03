#!/bin/bash

DELIMETER="|"

read -e -r -p "Front: " front
read -e -r -p "Back: " back
read -e -r -p "Type(basic): " type

record=""

# TYPE
record+=$type
record+=$DELIMETER

# BOX
record+="0"
record+=$DELIMETER

# REVIEW DATE
record+=$(date +"%Y-%m-%d %H:%M:%S")
record+=$DELIMETER

# FRONTSIDE
record+=$front
record+=$DELIMETER

# BACKSIDE
record+=$back


echo "$record" >> ~/shared-2/.deck.csv
