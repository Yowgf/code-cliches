#!/bin/bash

set -e

input_fpath=${1:-input.txt}

function is_number {
    [[ "$1" =~ ^[0-9]$ ]] && echo "y" && return
    echo "n"
}

function map_letter_number_to_number {
    case "$1" in
        one)
            echo 1
            ;;
        two)
            echo 2
            ;;
        three)
            echo 3
            ;;
        four)
            echo 4
            ;;
        five)
            echo 5
            ;;
        six)
            echo 6
            ;;
        seven)
            echo 7
            ;;
        eight)
            echo 8
            ;;
        nine)
            echo 9
            ;;
        *)
            printf ""
            ;;
    esac
}

sum=0
for line in $(cat "$input_fpath"); do
    for char in $(echo "$line" | sed 's/./& /g'); do
        if [ $(is_number "$char") != "y" ]; then
            letter_number="${letter_number}${char}"
            potential_number="$(map_letter_number_to_number "$letter_number")"
            if [ -z "$potential_number" ]; then
                continue
            fi
            # if [[ ! "$letter_number" =~ ^(one)|(two)|(three)|(four)|(five)|(six)|(seven)|(eight)|(nine)$ ]]; then
            #     continue
            # fi
            number="$potential_number"
        else
            number="$char"
        fi
        if [ -z "$first_number" ]; then
            first_number="$number"
        else
            last_number="$number"
        fi
        letter_number=""
    done
    if [ -z "$first_number" ]; then
        first_number=0
    fi
    if [ -z "$last_number" ]; then
        last_number="$first_number"
    fi
    final_number="${first_number}${last_number}"
    echo "Adding $final_number"
    (( sum += "$final_number" ))
    first_number=""
    last_number=""
    letter_number=""
done
echo "$sum"
