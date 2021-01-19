#! /bin/bash
if [[ $# -ne 1 ]] ; then
    echo "Usage: $0 number"
    exit -1
else
if [[ ! -e src/Day$1.re ]]; then
    touch src/Day$1.re
fi
if [[ ! -e src/input/day$1.txt ]]; then
    touch src/input/day$1.txt
fi
if [[ ! -e src/input/day$1_sample.txt ]]; then
    touch src/input/day$1_sample.txt
fi
fi