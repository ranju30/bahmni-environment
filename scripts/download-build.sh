rm -f $1/*

#openmrs-modules
wget -O $1/addresshierarchy-2.2.10-SNAPSHOT.omod https://ci-bahmni.thoughtworks.com/job/Build-Address-Hierarchy/lastSuccessfulBuild/artifact/omod/target/addresshierarchy-2.2.10-SNAPSHOT.omod
wget -O $1/bahmnicore-0.2-SNAPSHOT.omod https://ci-bahmni.thoughtworks.com/job/Build-Bahmni-Core/lastSuccessfulBuild/artifact/omod/target/bahmnicore-0.2-SNAPSHOT.omod
wget -O $1/bahmnicore-mail-appender-0.2-SNAPSHOT-jar-with-dependencies.jar https://ci-bahmni.thoughtworks.com/job/Build-Bahmni-Core/lastSuccessfulBuild/artifact/bahmni-mail-appender/target/bahmnicore-mail-appender-0.2-SNAPSHOT-jar-with-dependencies.jar
wget -O $1/jss-old-data-0.2-SNAPSHOT-jar-with-dependencies.jar https://ci-bahmni.thoughtworks.com/job/Build-Bahmni-Core/lastSuccessfulBuild/artifact/jss-old-data/target/jss-old-data-0.2-SNAPSHOT-jar-with-dependencies.jar
wget -O $1/bahmni-openmrs-webapp-1.9.4-SNAPSHOT.war https://ci-bahmni.thoughtworks.com/job/Build-OpenMRS-Core-Module/lastSuccessfulBuild/artifact/webapp/target/bahmni-openmrs-webapp-1.9.4-SNAPSHOT.war
wget -O $1/openmrs-data-jars.zip https://ci-bahmni.thoughtworks.com/job/Build-OpenMRS-Data/lastSuccessfulBuild/artifact/target/openmrs-data-jars.zip
wget -O $1/webservices.rest-1.2-SNAPSHOT.0a1e33.omod https://ci-bahmni.thoughtworks.com/job/Build-OpenMRS-Rest-Module/lastSuccessfulBuild/artifact/omod/target/webservices.rest-1.2-SNAPSHOT.0a1e33.omod

#client apps
wget -O $1/registration.zip https://ci-bahmni.thoughtworks.com/job/Build-Registration-UI/lastSuccessfulBuild/artifact/target/registration.zip
wget -O $1/bahmni-apps.zip https://ci-bahmni.thoughtworks.com/job/Build-Bahmni-Apps-UI/lastSuccessfulBuild/artifact/target/bahmni-apps.zip


#bahmni-openmrs modules
wget -O $1/bahmni.apps-1.0-SNAPSHOT.omod https://ci-bahmni.thoughtworks.com/job/Build-Bahmni-OpenMRS/lastSuccessfulBuild/artifact/openmrs-module-bahmni.apps/omod/target/bahmni.apps-1.0-SNAPSHOT.omod
wget -O $1/bhamni.opd-1.0-SNAPSHOT.omod https://ci-bahmni.thoughtworks.com/job/Build-Bahmni-OpenMRS/lastSuccessfulBuild/artifact/openmrs-module-bahmni.opd/omod/target/bhamni.opd-1.0-SNAPSHOT.omod
wget -O $1/bhamni.registration-1.0-SNAPSHOT.omod https://ci-bahmni.thoughtworks.com/job/Build-Bahmni-OpenMRS/lastSuccessfulBuild/artifact/openmrs-module-bahmni.registration/omod/target/bhamni.registration-1.0-SNAPSHOT.omod