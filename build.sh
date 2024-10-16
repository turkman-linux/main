#!/bin/bash
# It will compile all packages by generated order
find_path(){
    find "$1" -type d | grep -e "/$2$" | head -n 1
}
dir=$1
ymp info --deps \@${dir/\//.} | tr " " "\n" | while read line ; do
    path=$(find_path "$1" $line)
    if [ -f $path/ympbuild ] ; then
        echo ymp build --install --no-emerge --output=output $path
    fi
done