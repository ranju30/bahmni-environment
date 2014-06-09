# SCRIPT TO DOWNLOAD BUILDS FROM GO SERVER
# BE SURE TO EDIT THE VALUES BELOW FOR BUILD NUMBERS (DEFAULT IS LATEST)


BASE_URL=https://ci-bahmni.thoughtworks.com
MRS_Build_Name=1398
OpenERP_Build_Name=181
OpenELIS_Build_Name=170
reference_data_go_build_name=52
BRANCH=master
GO_USER=guest
GO_PWD=p@ssw0rd


echo "CI SERVER: $BASE_URL"

echo "Downloading artifact (1 of 12): bahmniapps.zip"
echo "--------------------------------------------------------------------------------------------------"
wget --user=$GO_USER --password=$GO_PWD --auth-no-challenge  $BASE_URL/go/files/Bahmni_MRS_$BRANCH/$MRS_Build_Name/BuildStage/Latest/FunctionalTests/deployables/bahmniapps.zip


echo "Downloading artifact (2 of 12): distro-4.0-SNAPSHOT-distro.zip"
echo "--------------------------------------------------------------------------------------------------"
wget --user=$GO_USER --password=$GO_PWD --auth-no-challenge  $BASE_URL/go/files/Bahmni_MRS_$BRANCH/$MRS_Build_Name/BuildDistroStage/Latest/BahmniDistro/openmrs-distro-bahmni-artifacts/distro-4.0-SNAPSHOT-distro.zip


echo "Downloading artifact (3 of 12): jss_config.zip"
echo "--------------------------------------------------------------------------------------------------"
wget --user=$GO_USER --password=$GO_PWD --auth-no-challenge  $BASE_URL/go/files/Bahmni_MRS_$BRANCH/$MRS_Build_Name/BuildStage/Latest/FunctionalTests/deployables/jss_config.zip

echo "Downloading artifact (4 of 12): jss-old-data-4.0-SNAPSHOT-jar-with-dependencies.jar"
echo "--------------------------------------------------------------------------------------------------"
wget --user=$GO_USER --password=$GO_PWD --auth-no-challenge  $BASE_URL/go/files/Bahmni_MRS_$BRANCH/$MRS_Build_Name/BuildStage/Latest/FunctionalTests/deployables/jss-old-data-4.0-SNAPSHOT-jar-with-dependencies.jar

echo "Downloading artifact (5 of 12): search_config.zip"
echo "--------------------------------------------------------------------------------------------------"
wget --user=$GO_USER --password=$GO_PWD --auth-no-challenge  $BASE_URL/go/files/Bahmni_MRS_$BRANCH/$MRS_Build_Name/BuildStage/Latest/FunctionalTests/deployables/search_config.zip

echo "Downloading artifact (6 of 12): openerp-atomfeed-service.war"
echo "--------------------------------------------------------------------------------------------------"
wget --user=$GO_USER --password=$GO_PWD --auth-no-challenge  $BASE_URL/go/files/OpenERP_$BRANCH/$OpenERP_Build_Name/runFunctionalTestsStage/Latest/openerp-atomfeed-service/openerp-atomfeed-service.war

echo "Downloading artifact (7 of 12): openerp-modules.zip"
echo "--------------------------------------------------------------------------------------------------"
wget --user=$GO_USER --password=$GO_PWD --auth-no-challenge  $BASE_URL/go/files/OpenERP_$BRANCH/$OpenERP_Build_Name/runFunctionalTestsStage/Latest/runFunctionalTestsJob/openerp-modules.zip

echo "Downloading artifact (8 of 12): openelis.war"
echo "--------------------------------------------------------------------------------------------------"
wget --user=$GO_USER --password=$GO_PWD --auth-no-challenge  $BASE_URL/go/files/OpenElis_$BRANCH/$OpenELIS_Build_Name/Build/Latest/build/openelis.war

echo "Downloading artifact (9 of 12): OpenElis.zip"
echo "--------------------------------------------------------------------------------------------------"
wget --user=$GO_USER --password=$GO_PWD --auth-no-challenge  $BASE_URL/go/files/OpenElis_$BRANCH/$OpenELIS_Build_Name/Build/Latest/build/OpenElis.zip

echo "Downloading artifact (10 of 12): reference-data-0.1.war"
echo "--------------------------------------------------------------------------------------------------"
wget --user=$GO_USER --password=$GO_PWD --auth-no-challenge  $BASE_URL/go/files/ReferenceData_$BRANCH/$reference_data_go_build_name/Build/Latest/build/deployables/reference-data-0.1.war

echo "Downloading artifact (11 of 12): reference-data-scripts.zip"
echo "--------------------------------------------------------------------------------------------------"
wget --user=$GO_USER --password=$GO_PWD --auth-no-challenge  $BASE_URL/go/files/ReferenceData_$BRANCH/$reference_data_go_build_name/Build/Latest/build/deployables/reference-data-scripts.zip

#Download ui-modules
mkdir ui-modules
cd ui-modules

echo "Downloading artifact (12 of 12): bahmniapps-4.0-SNAPSHOT.omod"
echo "--------------------------------------------------------------------------------------------------"
wget --user=$GO_USER --password=$GO_PWD --auth-no-challenge  $BASE_URL/go/files/Bahmni_MRS_$BRANCH/$MRS_Build_Name/BuildStage/Latest/FunctionalTests/deployables/ui-modules/bahmniapps-4.0-SNAPSHOT.omod 
