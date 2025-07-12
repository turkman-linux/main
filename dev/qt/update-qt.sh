#!/bin/bash
set -ex
ver="$1"
find . -type f -iname ympbuild | while read file ; do
    sed -i "s/version='.*'/version='$ver'/g" $file
    rel=$(bash -c "source $file &>/dev/null; echo \$release")
    rel=$(($rel+1))
    sed -i "s/release='.*'/release='$rel'/g" $file
done