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

declare -a allrepos=("openmrs-module-bahmniapps" "jss-config" "openerp-atomfeed-service" "OpenElis"
 "bahmni-core" "bahmni-java-utils" "openerp-modules" "openerp-functional-tests" "openmrs-distro-bahmni"
 "bahmni-environment" "emr-functional-tests")

rm -rf ~/Project/Bahmni/allrepos
mkdir ~/Project/Bahmni/allrepos
cd ~/Project/Bahmni/allrepos

. $3

for repo in "${allrepos[@]}"
do
   declare shaKey=$(echo "$repo" | tr '-' '_')
#   echo ${!shaKey}

   echo -e "${Blu}Cloning $repo ${RCol}"
   git clone git@github.com:Bhamni/$repo.git
   cd $repo
   echo -e "${Gre}Creating a branch for $repo - release-"${1/-SNAPSHOT/}"... ${RCol}"
   git branch release-"${1/-SNAPSHOT/}" ${!shaKey}
   find . -name "pom.xml" -exec sed -i '' 's/'${1/-SNAPSHOT/}'/'${2/-SNAPSHOT/}'/g'  {} \;
   find . -name "config.xml" -exec sed -i '' 's/'${1/-SNAPSHOT/}'/'${2/-SNAPSHOT/}'/g'  {} \;
   if [ -n "$(git status --porcelain)" ]; then
   	git diff > ../$repo.diff
   	echo -e "${Gre}Version changes in "$repo:master" ->  ./allrepos/$repo.diff ${RCol} "
   	git commit -am "upping the version to $2"
   fi
   cd ..
done
