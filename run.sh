#! /bin/bash
if [[ $# -ne 1 ]] ; then
    echo "Usage: $0 number"
    exit -1
else
    yarn build
    node src/day$1.bs.js
fi