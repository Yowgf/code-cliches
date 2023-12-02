#!/bin/bash

board_sidelen=$1
output_fpath=${2:-board-${board_sidelen}x${board_sidelen}.txt}

contents=""
for i in $(seq "$board_sidelen"); do
    for j in $(seq "$board_sidelen"); do
        num=$(expr $RANDOM % 3)
        if [ "$j" = "$board_sidelen" ]; then
            contents="${contents}$num"
        else
            contents="${contents}$num "
        fi
    done
    contents="$contents
"
done
printf "$contents" > "$output_fpath"
