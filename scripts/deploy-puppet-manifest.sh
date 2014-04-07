#!/bin/bash

SCRIPTS_DIR=`dirname $0`
BASE_DIR=$SCRIPTS_DIR/..

usage() {
	echo "Usage: run-puppet-manifest.sh <manifest-file>"
	echo "<manifest-file> is the name of a manifest file present in ${BASE_DIR}/puppet/manifests directory"
}

MODULE_NAME=$1
if [ "${MODULE_NAME}a" = "a" ]
then
	echo "Please specify a module to run)"
	usage
	exit 1
fi

####################################################################
# Checking if env variable BAHMNI_USER_NAME is set
echo "Current value of BAHMNI_USER_NAME = ${BAHMNI_USER_NAME}"

if [ "${BAHMNI_USER_NAME}a" = "a" ]
then
	# If not, then setting it to second parameter passed
	BAHMNI_USER_NAME=$2
fi

# If still not set.... 
if [ "${BAHMNI_USER_NAME}a" = "a" ]
then
	echo "No BAHMNI_USER_NAME specified. Assuming jss for backward compatability"
	BAHMNI_USER_NAME=jss
fi

export FACTER_bahmni_user_new=$BAHMNI_USER_NAME
echo "Setting bahmni_user=${FACTER_bahmni_user_new}"
####################################################################

puppet apply $BASE_DIR/puppet/manifests/$1.pp --modulepath=$BASE_DIR/puppet/modules/ --detailed-exitcodes
RETURN_CODE=$?
if [ $RETURN_CODE -ne 0 ] && [ $RETURN_CODE -ne 2 ]
then
	echo "Error running script. Return code = ${RETURN_CODE}. Exiting"
	exit 1
else 
	echo "All fine. Return code = ${RETURN_CODE}. Exiting"
	exit 0
fi