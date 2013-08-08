# $1 should be /packages/build folder
cd $1
rm -rf *
wget https://ci-bahmni.thoughtworks.com/go/files/Bahmni_MRS_Pipeline/Latest/BuildDistroStage/Latest/BahmniDistro/openmrs-distro-bahmni-artifacts/distro-1.0-SNAPSHOT-distro.zip
wget https://ci-bahmni.thoughtworks.com/go/files/Bahmni_MRS_Pipeline/Latest/BuildStage/Latest/FunctionalTests/deployables/registration.zip
wget https://ci-bahmni.thoughtworks.com/go/files/Bahmni_MRS_Pipeline/Latest/BuildStage/Latest/FunctionalTests/deployables/opd.zip
wget https://ci-bahmni.thoughtworks.com/go/files/Bahmni_MRS_Pipeline/Latest/BuildStage/Latest/FunctionalTests/deployables/bahmni-apps.zip
wget https://ci-bahmni.thoughtworks.com/go/files/Bahmni_MRS_Pipeline/Latest/BuildStage/Latest/FunctionalTests/deployables/jss-old-data-0.2-SNAPSHOT-jar-with-dependencies.jar
wget https://ci-bahmni.thoughtworks.com/go/files/Bahmni_MRS_Pipeline/Latest/BuildStage/Latest/FunctionalTests/deployables/openmrs-data-jars.zip

OPENElIS_BUILD="Latest"
wget https://ci-bahmni.thoughtworks.com/go/files/OpenElis/$OPENElIS_BUILD/Build/Latest/build/openelis.war
wget https://ci-bahmni.thoughtworks.com/go/files/OpenElis/$OPENElIS_BUILD/Build/Latest/build/OpenElis.zip


unzip distro-1.0-SNAPSHOT-distro.zip
cp distro-1.0-SNAPSHOT/* .