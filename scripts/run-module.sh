#!/bin/bash

set -e

SCRIPTS_DIR=`dirname $0`
BASE_DIR=$SCRIPTS_DIR/..
FACTER_module_to_run=$1 puppet apply $BASE_DIR/puppet/manifests/run.pp  --modulepath=$BASE_DIR/puppet/modules/  --detailed-exitcodes
RETURN_CODE=$?
if [ $RETURN_CODE -ne 2 ]
then
	echo "Error running script. Return code = ${RETURN_CODE}. Exiting"
	exit 1
fi