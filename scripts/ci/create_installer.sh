#/bin/bash

TEMP_SCRIPT_DIR=`dirname -- "$0"`
SCRIPT_DIR=`cd $TEMP_SCRIPT_DIR; pwd`
export SCRIPT_DIR

ARTIFACTS_DIRECTORY=$1
COMMAND=$2
INSTALLER_FILE=$SCRIPT_DIR/bahmni_installer.sh
INSTALLER_TEMPLATE=$SCRIPT_DIR/bahmni_installer.sh.template

usage() {
	echo "Usage: create_installer.sh <folder_containing_artifacts> <relative_path_of_deploy_command_from_artifacts_folder>"
	echo "You dumbo"
}

if [ $# -ne 2 ]
then
	usage
	exit 1
fi

sed "s|{{RUN_DEPLOY_SCRIPT}}|$COMMAND|g" $INSTALLER_TEMPLATE > $INSTALLER_FILE
tar czf - -C $ARTIFACTS_DIRECTORY . >> $INSTALLER_FILE
echo "Created $INSTALLER_FILE"