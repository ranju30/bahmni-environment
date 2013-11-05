# $1 should be /packages/build folder
if [ $# -lt 1 ]
then
        echo "Usage : $0 download_folder(/packages/build)"
        exit
fi

cd $1
rm -rf *

if [ $# -lt 2 ]
then
  BASE_URL=https://ci-bahmni.thoughtworks.com
fi

if [ $# -lt 3 ]
then
  BASE_URL=http://172.18.2.11:8153
fi

MRS_Build_Name=Latest
BRANCH=master

rm -f *

wget $BASE_URL/go/files/Bahmni_MRS_$BRANCH/$MRS_Build_Name/BuildDistroStage/Latest/BahmniDistro/openmrs-distro-bahmni-artifacts/distro-2.5-SNAPSHOT-distro.zip
wget $BASE_URL/go/files/Bahmni_MRS_$BRANCH/$MRS_Build_Name/BuildStage/Latest/FunctionalTests/deployables/registration.zip
wget $BASE_URL/go/files/Bahmni_MRS_$BRANCH/$MRS_Build_Name/BuildStage/Latest/FunctionalTests/deployables/opd.zip
wget $BASE_URL/go/files/Bahmni_MRS_$BRANCH/$MRS_Build_Name/BuildStage/Latest/FunctionalTests/deployables/home.zip
wget $BASE_URL/go/files/Bahmni_MRS_$BRANCH/$MRS_Build_Name/BuildStage/Latest/FunctionalTests/deployables/bahmni_config.zip
wget $BASE_URL/go/files/Bahmni_MRS_$BRANCH/$MRS_Build_Name/BuildStage/Latest/FunctionalTests/deployables/jss-old-data-2.5-SNAPSHOT-jar-with-dependencies.jar
wget $BASE_URL/go/files/Bahmni_MRS_$BRANCH/$MRS_Build_Name/BuildStage/Latest/FunctionalTests/deployables/openmrs-data-jars.zip
wget $BASE_URL/go/files/Bahmni_MRS_$BRANCH/$MRS_Build_Name/BuildStage/Latest/FunctionalTests/deployables/elisatomfeedclient-omod-beanshell.zip

wget $BASE_URL/go/files/OpenERP_$BRANCH/Latest/runFunctionalTestsStage/Latest/openerp-atomfeed-service/openerp-atomfeed-service.war

wget $BASE_URL/go/files/OpenElis_$BRANCH/Latest/Build/Latest/build/openelis.war
wget $BASE_URL/go/files/OpenElis_$BRANCH/Latest/Build/Latest/build/OpenElis.zip


unzip distro-2.5-SNAPSHOT-distro.zip
cp distro-2.5-SNAPSHOT/* .
