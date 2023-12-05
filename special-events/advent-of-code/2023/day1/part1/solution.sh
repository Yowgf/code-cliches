#!/bin/bash

set -e

input_fpath=${1:-input.txt}

function is_number {
    [[ "$1" =~ ^[0-9]$ ]] && echo "y" && return
    echo "n"
}

sum=0
for line in $(cat "$input_fpath"); do
    for char in $(echo "$line" | sed 's/./& /g'); do
        if [ $(is_number "$char") != "y" ]; then
            continue
        fi
        if [ -z "$first_number" ]; then
            first_number="$char"
        else
            last_number="$char"
        fi
    done
    if [ -z "$first_number" ]; then
        first_number=0
    fi
    if [ -z "$last_number" ]; then
        last_number="$first_number"
    fi
    (( sum += "${first_number}${last_number}" ))
    first_number=""
    last_number=""
done
echo "$sum"
