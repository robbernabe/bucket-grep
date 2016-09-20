#!/usr/bin/env bash

trap ctrl_c INT

SEARCH_TERMS="${1}"

function ctrl_c() {
    echo "Exiting due to CTRL-C"
}

function main() {
    FILES_TO_SEARCH=$(aws s3 ls s3://${BUCKET}/ --recursive | grep "${FILE_PREFIX}" | awk '{print $4}')
    for s3_file in ${FILES_TO_SEARCH}; do
        echo -n "Processing file: $s3_file "
        MATCHES=$(aws s3 cp s3://${BUCKET}/$s3_file - | bunzip2 | xmllint --format - | grep -o -f "${SEARCH_TERMS}" 2> /dev/null)
        if [[ $? -eq 0 ]]; then
            echo "[ MATCHES FOUND ]"
            echo ""
            printf '    %s\n' $MATCHES
            echo ""
            continue
        else
            echo "[ NO MATCHES FOUND ]"
        fi
    done
}

if [[ -z ${BUCKET} ]] || [[ -z ${FILE_PREFIX} ]]; then
    echo "Please set the required environment vars!"
    exit 1
elif [ $# -eq 0 ]; then
    echo "Please supply a search term!"
else
    main
fi

exit 0
