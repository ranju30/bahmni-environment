#!/bin/bash
function replace_installer_template {
	sed "s|{{RUN_DEPLOY_SCRIPT}}|$1|g" $INSTALLER_TEMPLATE > $INSTALLER_FILE
}

function create_installer {
	chmod +x $INSTALLER_FILE
	mkdir ./installer
	makeself.sh $ARTIFACTS_DIRECTORY ./installer/$INSTALLER_FILE_NAME "$INSTALLER_LABEL" $BAHMNI_INSTALLER_FILE
}

