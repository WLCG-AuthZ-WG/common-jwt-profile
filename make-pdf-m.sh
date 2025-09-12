#!/bin/bash

set -e

FILENAME="profile"
TMP=$(mktemp -d)
UTILS="utils"
TARGET="BUILD"
VERBOSE="nope"

while [ $# -gt 0 ]; do
    case "$1" in
    clean)      TARGET="CLEAN"                                          ;;
    -v)         VERBOSE="yep"                                           ;;
    esac
    shift
done

[ "x$TARGET" == "xBUILD" ] && {
    # echo "${FILENAME}"
    cat "${UTILS}/snippet.md" > "${TMP}/${FILENAME}.md"
    cat "${FILENAME}.md" >> "${TMP}/${FILENAME}.md"
    pandoc "${TMP}/${FILENAME}.md" -o "${FILENAME}.pdf" --lua-filter="${UTILS}/list-table.lua" > "${TMP}/pdf.log" 2>&1
    pandoc "${TMP}/${FILENAME}.md" -o "${FILENAME}.docx" --reference-doc "${UTILS}/style.docx" > "${TMP}/docx.log" 2>&1
}

[ "x$TARGET" == "xCLEAN" ] && {
    echo -n "${FILENAME}"
    rm -f ${FILENAME}.pdf ${FILENAME}.docx
    echo "...done"
}

[[ ${VERBOSE} == "yep" ]] && {
    cat ${TMP}/pdf.log
}

[ -d "${TMP}" ] && rm -rf "${TMP}"

exit 0
