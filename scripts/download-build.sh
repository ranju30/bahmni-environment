# $1 should be /packages/build folder
if [ $# -lt 1 ]
then
        echo "Usage : $0 download_folder(packages/build)"
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

wget $BASE_URL/go/files/Bahmni_MRS_Pipeline/Latest/BuildDistroStage/Latest/BahmniDistro/openmrs-distro-bahmni-artifacts/distro-1.0-SNAPSHOT-distro.zip
wget $BASE_URL/go/files/Bahmni_MRS_Pipeline/Latest/BuildStage/Latest/FunctionalTests/deployables/registration.zip
wget $BASE_URL/go/files/Bahmni_MRS_Pipeline/Latest/BuildStage/Latest/FunctionalTests/deployables/opd.zip
wget $BASE_URL/go/files/Bahmni_MRS_Pipeline/Latest/BuildStage/Latest/FunctionalTests/deployables/bahmni-apps.zip
wget $BASE_URL/go/files/Bahmni_MRS_Pipeline/Latest/BuildStage/Latest/FunctionalTests/deployables/jss-old-data-0.2-SNAPSHOT-jar-with-dependencies.jar
wget $BASE_URL/go/files/Bahmni_MRS_Pipeline/Latest/BuildStage/Latest/FunctionalTests/deployables/openmrs-data-jars.zip
wget $BASE_URL/go/files/Bahmni_MRS_Pipeline/Latest/BuildStage/Latest/FunctionalTests/deployables/elisatomfeedclient-omod-beanshell.zip

wget $BASE_URL/go/files/OpenERP_Pipeline/Latest/runFunctionalTestsStage/Latest/openerp-atomfeed-service/openerp-atomfeed-service.war

wget $BASE_URL/go/files/OpenElis/Latest/Build/Latest/build/openelis.war
wget $BASE_URL/go/files/OpenElis/Latest/Build/Latest/build/OpenElis.zip


unzip distro-1.0-SNAPSHOT-distro.zip
cp distro-1.0-SNAPSHOT/* .
