#/bin/bash
TEMP_SCRIPT_DIR=`dirname -- "$0"`
SCRIPT_DIR=`cd $TEMP_SCRIPT_DIR; pwd`
export SCRIPT_DIR
$SCRIPT_DIR/installer_utils.sh $@

function usage {
	echo "Usage: create_installer.sh ARCHIVE_DIRECTORY FILE_NAME LABEL COMMAND"
}

function check_arguments {
	if [ $# -ne 4 ]
	then
		usage
		exit 1
	fi	
}

check_arguments
replace_installer_template "run-puppet-manifest.sh $COMMAND"
create_installer