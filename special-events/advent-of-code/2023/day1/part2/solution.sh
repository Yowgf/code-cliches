#!/bin/bash

set -e

input_fpath=${1:-input.txt}

function is_number {
    [[ "$1" =~ ^[0-9]$ ]] && echo "y" && return
    echo "n"
}

function map_letter_number_to_number {
    letter_number="$1"
    is_reverse="$2"
    if [ "$is_reverse" = y ]; then
        letter_number="$(echo "$letter_number" | rev)"
    fi
    case "$letter_number" in
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

# We need a something like a prefix tree, like the following:
#
#                           o     t     f     s    e     n
#                          /    / |   / |   / |    |     |
#                         n    w  h  o  i  i  e    i     i
#                        /     |  |  |  |  |  |    |     |
#                       e      o  r  u  v  x  v    g     n
#                                 |  |  |     |    |     |
#                                 e  r  e     e    h     e
#                                 |           |    |
#                                 e           n    t
#
# number_tree is a state machine that you can access as follows:
#
# >> state=
# >> input=o
# >> number_tree[$state,$input]
# o
#
# >> state=o
# >> input=n
# >> number_tree[$state,$input]
# on
#
# Example of failed match (returns empty string)
#
# >> state=on
# >> input=b
# >> number_tree[$state,$input]
# 
#
# Example of successful match:
#
# >> state=on
# >> input=e
# >> number_tree[$state,$input]
# one
#
# This logic is encapsulated in the function tree_at
declare -A number_tree
declare -A number_tree_reverse

function explode_string {
    echo "$1" | sed 's/./& /g'
}

function build_number_trees {
    for word in one two three four five six seven eight nine; do
        chars=$(explode_string "$word")
        word_part=""
        for char in $chars; do
            number_tree["${word_part},${char}"]="${word_part}${char}"
            word_part="${word_part}${char}"
        done
        word_part=""
        for char in $(echo "$chars" | rev); do
            number_tree_reverse["${word_part},${char}"]="${word_part}${char}"
            word_part="${word_part}${char}"
        done
    done
}

# tree_at returns the next state, given current state and input.
function tree_at {
    state="$1"
    input="$2"
    echo "${number_tree[$state,$input]}"
}

# reverse_tree_at returns the next state in the reverse number tree, given
# current state and input.
function reverse_tree_at {
    state="$1"
    input="$2"
    echo "${number_tree_reverse[$state,$input]}"
}

function update_letter_number {
    cur_letter_number="$1"
    new_char="$2"
    is_reverse="$3"

    while [ "$cur_letter_number" != "" ]; do
        if [ "$is_reverse" != "y" ]; then
            potential_new_state="$(tree_at "$cur_letter_number" "$new_char")"
        else
            potential_new_state="$(reverse_tree_at "$cur_letter_number" "$new_char")"
        fi
        if [ -n "$potential_new_state" ]; then
            echo "$potential_new_state"
            return
        fi
        cur_letter_number="${cur_letter_number:1}"
    done
    # No match, start from beginning
    echo "$new_char"
}

function find_first_number {
    str="$1"
    is_reverse="$2"
    first_number=""
    letter_number=""
    for char in $str; do
        is_number=$(is_number "$char")
        # echo "Working with $char, for which is_number=$is_number" 1>&2
        if [ "$is_number" != "y" ]; then
            letter_number="$(update_letter_number "$letter_number" "$char" "$is_reverse")"
            potential_number="$(map_letter_number_to_number "$letter_number" "$is_reverse")"
            if [ -z "$potential_number" ]; then
                continue
            fi
            echo "Got $potential_number from $letter_number" 1>&2
            first_number="$potential_number"
        else
            first_number="$char"
        fi
        break
    done
    echo "$first_number"
}

build_number_trees
sum=0
for line in $(cat "$input_fpath"); do
    line_list=$(explode_string "$line")
    first_number=$(find_first_number "$line_list")
    last_number=$(find_first_number "$(echo "$line_list" | rev)" 'y')
    aggregate_number="${first_number}${last_number}"
    echo "Adding $aggregate_number" 1>&2
    (( sum += aggregate_number ))
done
echo "$sum"
