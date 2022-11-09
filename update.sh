#!/bin/bash
set -e
move_source(){
    mkdir -p output
    find -type f  | grep -v "output"| grep "source.ymp$" | sort -V | while read line ; do
        mv $line output
    done
}
find -type f | grep ympbuild | sort -V | while read line ; do
    name=$(basename $(dirname $line))
    path=$(realpath $(dirname $line))
    if ! find ./output/ -type f | grep "${name}_" | grep "source.ymp$" 2>/dev/null ; then
        echo -e "\033[33;1m=>> SOURCE BUILD START:\033[;0m $line"
        ymp --sandbox --shared="$path" build "$path" --verbose --no-binary --ignore-dependency --allow-oem
        move_source
        echo -e "\033[33;1m<<= SOURCE BUILD DONE:\033[;0m $line"
    fi
done
ymp index output --allow-oem --verbose --move

