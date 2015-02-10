#!/bin/bash

set -e

implementation_name=$1

if [ -z "$implementation_name" ]
then
	echo "Please Provide an implementation name"
	exit 1
fi

sudo fuser -k 8080/tcp || :
sudo -E sh all_installer.sh --target /packages/build
sudo -E sh ${implementation_name}_config_installer.sh --target /packages/build
cp /bahmni_temp/logs/bahmni_deploy.log .
sudo service tomcat start
sudo service openerp restart