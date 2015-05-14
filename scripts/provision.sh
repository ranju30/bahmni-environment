#!/bin/bash

SCRIPTS_DIR=`dirname $0`
BASE_DIR=$SCRIPTS_DIR/..

usage() {
	echo "Usage: provision.sh <server_type>"
	echo "<server_type> is the name of a manifest file present in ${BASE_DIR}/puppet/nodes directory"
}

SERVER_TYPE=$1
if [ "${SERVER_TYPE}a" = "a" ]
then
	echo "Please specify a node to run)"
	usage
	exit 1
fi

export FACTER_server_type=$SERVER_TYPE
puppet apply $BASE_DIR/puppet/manifests/provision.pp --modulepath=$BASE_DIR/puppet/modules/:$BASE_DIR/puppet --detailed-exitcodes
RETURN_CODE=$?
if [ $RETURN_CODE -ne 0 ] && [ $RETURN_CODE -ne 2 ]
then
	echo "Error running script. Return code = ${RETURN_CODE}. Exiting"
	exit 1
else
	echo "All fine. Return code = ${RETURN_CODE}. Exiting"
	exit 0
fi

