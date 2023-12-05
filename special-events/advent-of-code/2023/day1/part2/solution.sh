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
# SUCCESS
#
# This logic is encapsulated in the function state_machine_ate
#
# TODO: write function that automatically builds number_tree
declare -A number_tree
number_tree[,o]=o
number_tree[o,n]=on
number_tree[on,e]=one
# t
number_tree[,t]=t
# two
number_tree[t,w]=tw
number_tree[tw,o]=two
# three
number_tree[t,h]=th
number_tree[th,r]=thr
number_tree[thr,e]=thre
number_tree[thre,e]=three
# f
number_tree[,f]=f
# four
number_tree[f,o]=fo
number_tree[fo,u]=fou
number_tree[fou,r]=four
# five
number_tree[f,i]=fi
number_tree[fi,v]=fiv
number_tree[fiv,e]=five
# s
number_tree[,s]=s
# six
number_tree[s,i]=si
number_tree[si,x]=six
# seven
number_tree[s,e]=se
number_tree[se,v]=sev
number_tree[sev,e]=seve
number_tree[seve,n]=seven
# eight
number_tree[,e]=e
number_tree[e,i]=ei
number_tree[ei,g]=eig
number_tree[eig,h]=eigh
number_tree[eigh,t]=eight
# nine
number_tree[,n]=n
number_tree[n,i]=ni
number_tree[ni,n]=nin
number_tree[nin,e]=nine

function explode_string {
    $(echo "$1" | sed 's/./& /g')
}

function build_number_trees {
    declare -A number_tree
    declare -A number_tree_reverse
    for word in one two three four five six seven eight nine; do
        chars=$(explode_string "$word")
        word_part=""
        for char in $chars; do
            number_tree["${word_part},${char}"] = "$word_part"
            word_part="${word_part}${char}"
        done
        for char in $(echo "$chars" | rev); do
            number_tree_reverse["${word_part},${char}"] = "$word_part"
            word_part="${word_part}${char}"
        done
    done
}

# state_macine_at returns the next state, given current state and input.
function state_machine_at {
    state="$1"
    input="$2"
    echo "${number_tree[$state,$input]}"
}

function update_letter_number {
    cur_letter_number="$1"
    new_char="$2"

    potential_new_state="$(state_machine_at "$cur_letter_number" "$new_char")"
    if [ -z "$potential_new_state" ]; then
        # No match, start from beginning
        echo "$new_char"
    else
        echo "$potential_new_state"
    fi
}

function find_first_number {
    first_number=""
    last_number=""
    letter_number=""
    for char in $1; do
        if [ $(is_number "$char") != "y" ]; then
            letter_number="$(update_letter_number "$letter_number" "$char")"
            potential_number="$(map_letter_number_to_number "$letter_number")"
            if [ -z "$potential_number" ]; then
                continue
            fi
            echo "Got $potential_number from $letter_number" 1>&2
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
    echo "Adding $final_number" 1>&2
    (( sum += "$final_number" ))
}

sum=0
for line in $(cat "$input_fpath"); do
    line_list=$(explode_string "$line")
    first_number=$(find_first_number "$line_list")
    last_number=$(find_first_number $(echo "$line_list" | rev))
done
echo "$sum"
