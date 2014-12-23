#!/bin/bash

RCol='\x1B[0m'; Red='\x1B[0;31m'; Gre='\x1B[0;32m'; Yel='\x1B[0;33m'; Blu='\x1B[0;34m';


usage() {
	echo "Usage: pushbranch.sh <branch-name>"
}

if [  $# -le 0 ] 
then
	usage
	exit 1
fi
declare -a allrepos=("openerp-atomfeed-service" "openmrs-module-bahmniapps" "jss-config"
 "search-config" "OpenElis" "bahmni-core" "bahmni-java-utils" "reference-data"
 "openerp-modules" "openerp-functional-tests" "openmrs-distro-bahmni" "bahmni-environment" 
 "openmrs-module-bedmanagement")

cd allrepos

for repo in "${allrepos[@]}"
do
   cd $repo
   echo -e "${Gre}Pushing branch $1 for $repo ${RCol}"
   git push origin $1
   cd ..
done
