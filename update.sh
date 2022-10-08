#!/bin/bash
find -type f | grep ympbuild | while read line ; do
    echo -e "\033[33;1m=>> SOURCE BUILD START:\033[;0m $line"
    ymp build $(dirname $line) --verbose --no-binary --ignore-dependency --allow-oem
        echo -e "\033[33;1m<<= SOURCE BUILD DONE:\033[;0m $line"
done
[[ -d output ]] && rm -rf output
mkdir -p output
find -type f | grep "source.ymp$" | sort -V | while read line ; do
    mv $line output
    echo "* <a href=\"$(basename $line)\">$(basename $line)</a><br>" >> output/index.html
done
ymp index output --allow-oem
echo "* <a href=\"ymp-index.yaml\">ymp-index.yaml</a><br>" >> output/index.html >> output/index.html
