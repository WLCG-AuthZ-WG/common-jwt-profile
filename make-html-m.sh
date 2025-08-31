#!/bin/bash
#date  >> /tmp/log

FILENAME=profile
MAX_WIDTH=960
UTILS=utils
STYLE_FILE="${UTILS}/style_internal_css.html"


while [ $# -gt 0 ]; do
    case "$1" in
    -i|--input)         FILENAME=$2;                             shift;;
    -w|--width)         MAX_WIDTH=$2;                              shift;;
    -s|--style)         STYLE_FILE=$2;                             shift;;
    esac
    shift
done

export MAX_WIDTH

cat "${STYLE_FILE}" | envsubst > "${FILENAME}.html"
pandoc -f gfm -t html {${FILENAME}.md} >> "${FILENAME}.html"
