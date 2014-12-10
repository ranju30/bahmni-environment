#!/bin/bash

GO_USER=guest
GO_PWD=p@ssw0rd
BASE_URL="http://172.18.2.11:8153"
ping -q -c1 172.18.2.11
LOCAL_SERVER=$?
if [ $LOCAL_SERVER -ne 0 ]
	then
	BASE_URL="https://ci-bahmni.thoughtworks.com"
fi

BRANCH=master
ARTIFACTS_PIPELINE_VERSION="Latest"
CONFIG_PIPELINE_VERSION="Latest"

wget --user=$GO_USER --password=$GO_PWD --auth-no-challenge  $BASE_URL/go/files/Bahmni_artifacts_$BRANCH/$ARTIFACTS_PIPELINE_VERSION/CollectArtefactsStage/Latest/defaultJob/all_installer.sh -O /packages/build/all_installer.sh
wget --user=$GO_USER --password=$GO_PWD --auth-no-challenge  $BASE_URL/go/files/Build_${FACTER_implementation_name}_config_$BRANCH/$CONFIG_PIPELINE_VERSION/Package/Latest/package/${FACTER_implementation_name}_config_installer.sh -O /packages/build/${FACTER_implementation_name}_config_installer.sh
