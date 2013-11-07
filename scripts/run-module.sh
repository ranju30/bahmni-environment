#!/bin/bash

SCRIPTS_DIR=`dirname $0`
BASE_DIR=$SCRIPTS_DIR/..
FACTER_module_name="$1" puppet apply $BASE_DIR/puppet/manifests/run.pp  --modulepath=$BASE_DIR/puppet/modules/
RETURN_CODE=$?
if [ $RETURN_CODE -ne 2 ]
then
	echo "Error running script. Return code = ${RETURN_CODE}. Exiting"
	exit 1
fi