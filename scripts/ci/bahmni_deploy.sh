#!/bin/sh -e

erp_installer_file=erp_installer.sh
elis_installer_file=elis_installer.sh
mrs_installer_file=mrs_installer.sh
bahmni_reports_installer_file=bahmni_reports_installer.sh

TEMP_SCRIPT_DIR=`dirname -- "$0"`
SCRIPT_DIR=`cd $TEMP_SCRIPT_DIR; pwd`
export SCRIPT_DIR

sh $SCRIPT_DIR/$mrs_installer_file

sh $SCRIPT_DIR/$elis_installer_file

sh $SCRIPT_DIR/$bahmni_reports_installer_file

if [ -f $SCRIPT_DIR/$erp_installer_file ]; then
    sh $SCRIPT_DIR/$erp_installer_file
fi

echo "Installation Complete"
