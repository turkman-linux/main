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
    if ! find ./output/ -type f | grep "${name}/${name}_" | grep "source.ymp$" &>/dev/null ; then
        echo -e "\033[33;1m=>> SOURCE BUILD START:\033[;0m $line"
        ymp --sandbox --shared="$path" build "$path" --no-binary --ignore-dependency --use=all --allow-oem --verbose || exit 1
        move_source
        echo -e "\033[33;1m<<= SOURCE BUILD DONE:\033[;0m $line"
    fi
done
ymp repo --index output --allow-oem --move --name="main" 

