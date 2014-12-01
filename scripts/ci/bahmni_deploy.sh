#!/bin/sh -e

erp_installer_file=erp_installer.sh
elis_installer_file=elis_installer.sh
mrs_installer_file=mrs_installer.sh
implementation_installer_file=$1

TEMP_SCRIPT_DIR=`dirname -- "$0"`
SCRIPT_DIR=`cd $TEMP_SCRIPT_DIR; pwd`
export SCRIPT_DIR

sh $SCRIPT_DIR/$erp_installer_file --target /packages/build
sh $SCRIPT_DIR/$elis_installer_file --target /packages/build
sh $SCRIPT_DIR/$mrs_installer_file --target /packages/build

if [ -f $SCRIPT_DIR/$implementation_installer_file ]; then
	sh $implementation_installer_file --target /packages/build
fi

echo "Installation Complete"