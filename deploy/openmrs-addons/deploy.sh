#!/bin/bash

if [ $# -lt 1 ]; then
   echo "Usage: $0 property-file-path"
   exit 1
fi

BASE_DIR=`dirname $0`

ant -Dproperty.file=$1 -f $BASE_DIR/build.xml