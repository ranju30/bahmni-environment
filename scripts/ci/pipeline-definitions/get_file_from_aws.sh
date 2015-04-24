#!/bin/bash

CONFIG_NAME=$1
FNAME=$2
DOWNLOAD_DIR=$3
BUCKET="bahmni-backup"
FILE_PATH="backups/$CONFIG_NAME/$FNAME"
FULL_PATH="/${BUCKET}/${FILE_PATH}"
REQUEST_DATE="`date +'%a, %d %b %Y %H:%M:%S %z'`"
CONTENT_TYPE="application/x-compressed-tar"
GET_REQUEST="GET

${CONTENT_TYPE}
${REQUEST_DATE}
${FULL_PATH}"
AWS_ACCESS_KEY="AKIAIHLRAGR2LCL6BSAQ"
AWS_SECRET_KEY="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"
signature=`/bin/echo -en "$GET_REQUEST" | openssl sha1 -hmac ${AWS_SECRET_KEY} -binary | base64`
echo $signature


curl -H "Host: ${BUCKET}.s3.amazonaws.com" -H "Date: ${REQUEST_DATE}" -H "Content-Type: ${CONTENT_TYPE}" -H "Authorization: AWS ${AWS_ACCESS_KEY}:${signature}" https://${BUCKET}.s3.amazonaws.com/${FILE_PATH} -o $DOWNLOAD_DIR/$FNAME