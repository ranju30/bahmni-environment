#!/bin/bash

set -e

if [ $# -lt 2 ]; then
   echo "Usage: $0 properties-file openmrs-data-jars-zip-path"
   exit 1
fi

SCRIPTS_DIR=`dirname $0`
BASE_DIR=$SCRIPTS_DIR/..
PROPERTIES_FILE=$1
OPEMRS_DATA_ZIP_FILE=$2
export OPENMRS_PROP_FILE=$1

if ! [ -f $1 ]; then
	echo "Could not find properties file $1"
	exit 1
fi

unzip -q -o $OPEMRS_DATA_ZIP_FILE -d $BASE_DIR/lib

set +e
ant db.init -propertyfile $PROPERTIES_FILE -f $BASE_DIR/build.xml 2>/tmp/flyway.init.error
set -e

ant db.migrate -propertyfile $PROPERTIES_FILE -f $BASE_DIR/build.xml