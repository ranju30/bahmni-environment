#!/bin/sh -e

erp_installer_file=$1
elis_installer_file=$2
mrs_installer_file=$3
implementation_installer_file=$4

TEMP_SCRIPT_DIR=`dirname -- "$0"`
SCRIPT_DIR=`cd $TEMP_SCRIPT_DIR; pwd`
export SCRIPT_DIR

if [ ! -f $SCRIPT_DIR/$erp_installer_file ]; then
	echo "$erp_installer_file should be at the same location as this script"
	exit 1
fi

if [ ! -f $SCRIPT_DIR/$elis_installer_file ]; then
	echo "$elis_installer_file should be at the same location as this script"
	exit 1
fi

if [ ! -f $SCRIPT_DIR/$mrs_installer_file ]; then
	echo "$mrs_installer_file should be at the same location as this script"
	exit 1
fi

sh $SCRIPT_DIR/$erp_installer_file
sh $SCRIPT_DIR/$elis_installer_file
sh $SCRIPT_DIR/$mrs_installer_file

if [ -f $SCRIPT_DIR/$implementation_installer_file ]; then
	sh $SCRIPT_DIR/$implementation_installer_file
fi

echo "Installation Complete"