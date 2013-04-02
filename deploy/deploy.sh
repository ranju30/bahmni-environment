#!/bin/bash

if [ $# -lt 2 ]; then
   echo "Usage: $0 deployables-path tomcat-webapps-dir"
   exit 1
fi

DEPLOYABLES_PATH=$1
TOMCAT_WEBAPPS_DIR=$2

set -x

#Run liquibase migration to create openmrs schema


#Configuration data migration for jss
./openmrs-data/scripts/deploy.sh $DEPLOYABLES_PATH/openmrs-data-jars.zip


./openmrs-modules/scripts/upload-modules.sh  $DEPLOYABLES_PATH/omod/target/webservices.rest-1.2-SNAPSHOT.b3189c.omod "http://modules.openmrs.org/modules/download/webservices.rest19ext/webservices.rest19ext-1.0.29298.omod"
"http://modules.openmrs.org/modules/download/idgen/idgen-2.4.1.omod" $DEPLOYABLES_PATH/omod/target/raxacore-0.2-SNAPSHOT.omod


./registration/scripts/deploay.sh $DEPLOYABLES_PATH/registration.zip $TOMCAT_WEBAPPS_DIR