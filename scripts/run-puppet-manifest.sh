#!/bin/bash

SCRIPTS_DIR=`dirname $0`
BASE_DIR=$SCRIPTS_DIR/..
puppet apply $BASE_DIR/puppet/manifests/$1.pp --modulepath=$BASE_DIR/puppet/modules/ --detailed-exitcodes
RETURN_CODE=$?
if [ $RETURN_CODE -ne 2 ]
then
	echo "Error running script. Return code = ${RETURN_CODE}. Exiting"
	exit 1
fi