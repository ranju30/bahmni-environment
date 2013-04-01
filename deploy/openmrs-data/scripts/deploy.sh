#!/bin/bash

set -e

if [ $# -lt 1 ]; then
   echo "Usage: $0 openmrs-data-jars-zip-path [openmrs-prop-file]"
   exit 1
fi

SCRIPTS_DIR=`dirname $0`
BASE_DIR=$SCRIPTS_DIR/..

if [ -z $2 ]; then
	export OPENMRS_PROP_FILE=$BASE_DIR/conf/openmrs-data.properties
else
	export OPENMRS_PROP_FILE=$2
fi

unzip -o ${1} -d $BASE_DIR/lib
ant db.migrate
