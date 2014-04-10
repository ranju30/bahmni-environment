#!/bin/bash

SCRIPTS_DIR=`dirname $0`
BASE_DIR=$SCRIPTS_DIR/..

usage() {
	echo "Usage: run-module.sh <module-name>"
	echo "<module-name> is the name of a puppet module present in ${BASE_DIR}/puppet/modules directory"
}

####################################################################
# Note that you should invoke this script with sudo -E (so that environment variables are passed to this script)
# Checking if env variable BAHMNI_USER_NAME is set

if [ "${BAHMNI_USER_NAME}a" != "a" ]
then
	export FACTER_bahmni_user_name=$BAHMNI_USER_NAME
	echo "Setting bahmni_user_name=${FACTER_bahmni_user_name}"
else
	echo "Not setting bahmni_user_name. Puppet default will be used."
fi

####################################################################
# Checking if env variable IMPLEMENTATION_NAME is set

if [ "${IMPLEMENTATION_NAME}a" != "a" ]
then
	export FACTER_implementation_name=$IMPLEMENTATION_NAME
	echo "Setting implementation_name=${FACTER_implementation_name}"
else
	echo "Not setting implementation_name. Puppet default will be used."
fi

####################################################################


MODULE_NAME=$1
if [ "${MODULE_NAME}a" = "a" ]
then
	echo "Please specify a module to run)"
	usage
	exit 1
fi

FACTER_module_to_run=$MODULE_NAME puppet apply $BASE_DIR/puppet/manifests/run.pp  --modulepath=$BASE_DIR/puppet/modules/  --detailed-exitcodes
RETURN_CODE=$?
if [ $RETURN_CODE -ne 0 ] && [ $RETURN_CODE -ne 2 ]
then
	echo "Error running script. Return code = ${RETURN_CODE}. Exiting"
	exit 1
else 
	echo "All fine. Return code = ${RETURN_CODE}. Exiting"
	exit 0
fi