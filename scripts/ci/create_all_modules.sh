#/bin/bash
TEMP_SCRIPT_DIR=`dirname -- "$0"`
SCRIPT_DIR=`cd $TEMP_SCRIPT_DIR; pwd`
export SCRIPT_DIR
export IMPLEMENTATION=$1

sh $SCRIPT_DIR/create_module_installer.sh deployables mrs_installer.sh "MRS Installer" bahmni_openmrs
sh $SCRIPT_DIR/create_module_installer.sh deployables-implementation $IMPLEMENTATION"_config_installer.sh" "Implementation Config Installer" implementation_config::openmrs
sh $SCRIPT_DIR/create_module_installer.sh deployables-elis elis_installer.sh "Elis Installer" bahmni_openelis
sh $SCRIPT_DIR/create_module_installer.sh deployables-erp erp_installer.sh "ERP Installer" bahmni_openerp

rm -rf final
mkdir -p final
mv mrs_installer.sh final/
mv $IMPLEMENTATION"_config_installer.sh" final/
mv elis_installer.sh final/
mv erp_installer.sh final/

cp $SCRIPT_DIR/bahmni_deploy.sh final

sh $SCRIPT_DIR/create_bahmni_installer.sh final all_installer.sh "Bahmni Installer"