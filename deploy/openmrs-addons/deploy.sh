#!/bin/bash

if [ $# -lt 1 ]; then
   echo "Usage: $0 property-file-path"
   exit 1
fi

BASE_DIR=`dirname $0`

export PATH=$PATH:/home/jss/apache-ant-1.9.0/bin

JAVA_VER=$(java -version 2>&1 | sed 's/java version "\(.*\)\.\(.*\)\..*"/\1\2/; 1q')
if [ "$JAVA_VER" -lt 17 ]; then
	echo "Please make sure java version is 1.7"
	exit 1
fi
	

ant -Dproperty.file=$1 -f $BASE_DIR/build.xml