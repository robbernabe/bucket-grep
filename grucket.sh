#!/usr/bin/env bash

set -e

trap ctrl_c INT

GREP_TERM=${1}

function ctrl_c() {
    echo "Exiting due to CTRL-C"
}

function main() {
    for s3_file in $(aws s3 ls s3://${BUCKET}/ --recursive | grep "${FILE_PREFIX}" | awk '{print $4}'); do
        aws s3 cp s3://${BUCKET}/$s3_file - | bunzip2 | xmllint --format - | grep "${GREP_TERM}"
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
