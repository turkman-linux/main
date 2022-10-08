#!/bin/bash
find -type f | grep ympbuild | while read line ; do
    ymp build $(dirname $line) --verbose --no-binary --ignore-dependency --allow-oem
done
[[ -d output ]] && rm -rf output
mkdir -p output
find -type f | grep "source.ymp$" | while read line ; do
    mv $line output
done
ymp index output --allow-oem
