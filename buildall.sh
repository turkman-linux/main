#!/bin/bash
set -e
find -type f | grep ympbuild | sort -V | while read line ; do
    echo -e "\033[33;1m=>> BINARY BUILD START:\033[;0m $line"
    name=$(basename $(dirname $line))
    if ! ls ./output/${name}_*$(uname -m).ymp ; then
        ymp build $(dirname $line) --verbose --no-source --ignore-dependency --allow-oem
    fi
    echo -e "\033[33;1m<<= BINARY BUILD DONE:\033[;0m $line"
done
mkdir -p output
echo "<h1><b>YMP index:</b></h1><br>" > output/index.html
find -type f  | grep -v "output"| grep "$(uname -m).ymp$" | sort -V | while read line ; do
    mv $line output
    echo "* <a href=\"$(basename $line)\">$(basename $line)</a><br>" >> output/index.html
done
ymp index output --allow-oem --verbose
echo "* <a href=\"ymp-index.yaml\">ymp-index.yaml</a><br>" >> output/index.html
