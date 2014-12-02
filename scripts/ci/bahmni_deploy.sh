#!/bin/sh -e

erp_installer_file=erp_installer.sh
elis_installer_file=elis_installer.sh
mrs_installer_file=mrs_installer.sh

TEMP_SCRIPT_DIR=`dirname -- "$0"`
SCRIPT_DIR=`cd $TEMP_SCRIPT_DIR; pwd`
export SCRIPT_DIR

if [ ${FACTER_deploy_bahmni_openerp}a != "falsea" ]
then
  sh $SCRIPT_DIR/$erp_installer_file --target /packages/build
fi

if [ ${FACTER_deploy_bahmni_openelis}a != "falsea" ]
then
  sh $SCRIPT_DIR/$elis_installer_file --target /packages/build
fi

sh $SCRIPT_DIR/$mrs_installer_file --target /packages/build

echo "Installation Complete"