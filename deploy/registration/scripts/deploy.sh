#!/bin/bash

set -e

if [ $# -ne 2 ]; then
   echo "Usage: $0 registration-zip-file-path tomcat-webapps-dir"
   exit 1
fi

unzip -o ${1} -d ${2}/registration
