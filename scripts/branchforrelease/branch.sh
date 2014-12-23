#!/bin/bash

RCol='\x1B[0m'; Red='\x1B[0;31m'; Gre='\x1B[0;32m'; Yel='\x1B[0;33m'; Blu='\x1B[0;34m';

usage() {
	echo "Usage: branch.sh <old-version> <new-version>"
	echo "<old-version> is the current bahmni version"
	echo "<new-version> is the next version"
}

if [  $# -le 1 ] 
then
	usage
	exit 1
fi

declare -a allrepos=("openerp-atomfeed-service" "openmrs-module-bahmniapps" "jss-config"
 "search-config" "OpenElis" "bahmni-core" "bahmni-java-utils" "reference-data"
 "openerp-modules" "openerp-functional-tests" "openmrs-distro-bahmni" "bahmni-environment" 
 "openmrs-module-bedmanagement")

rm -rf allrepos
mkdir allrepos
cd allrepos

for repo in "${allrepos[@]}"
do
   echo -e "${Blu}Cloning $repo ${RCol}"
   git clone git@github.com:Bhamni/$repo.git
   cd $repo
   echo -e "${Gre}Creating a branch for $repo - release-"${1/-SNAPSHOT/}"... ${RCol}"
   git branch release-"${1/-SNAPSHOT/}"
   find . -name "pom.xml" -exec sed -i '' 's/5.0-SNAPSHOT/5.1-SNAPSHOT/g'  {} \;
   find . -name "config.xml" -exec sed -i '' 's/5.0-SNAPSHOT/5.1-SNAPSHOT/g'  {} \;
   if [ -n "$(git status --porcelain)" ]; then
   	git diff > ../$repo.diff
   	echo -e "${Gre}Version changes in "$repo:master" ->  ./allrepos/$repo.diff ${RCol} "
   	git commit -am "upping the version to $2"
   fi
   cd ..
done
