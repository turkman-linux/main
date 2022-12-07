#!/bin/bash
set -e
move_package(){
    mkdir -p output
    find -type f  | grep -v "output"| grep "$(uname -m).ymp$" | sort -V | while read line ; do
        mv $line output
    done
}
find -type f | grep ympbuild | sort -V | while read line ; do
    name=$(basename $(dirname $line))
    path=$(realpath $(dirname $line))
    if ! find ./output/ -type f | grep "${name}/${name}_" | grep "$(uname -m).ymp$" &>/dev/null ; then
        echo -e "\033[33;1m<<= BINARY BUILD DONE:\033[;0m $line"
        ymp --sandbox --shared="$path" build "$path" --no-source --ignore-dependency --use=all --allow-oem --ignore-ssl || exit 1
        move_package
        echo -e "\033[33;1m<<= BINARY BUILD DONE:\033[;0m $line"
    fi
done

ymp repo --index output --allow-oem --move --name="main"
