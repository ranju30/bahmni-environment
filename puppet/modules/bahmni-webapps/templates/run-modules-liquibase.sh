#!/bin/sh
set -e -x
#start up  - to be run before all modules

CHANGE_LOG_TABLE="-Dliquibase.databaseChangeLogTableName=liquibasechangelog -Dliquibase.databaseChangeLogLockTableName=liquibasechangeloglock"
LIQUIBASE_JAR="openmrs/WEB-INF/lib/liquibase-core-2.0.5.jar"
DRIVER="com.mysql.jdbc.Driver"
CREDS="--url=jdbc:mysql://localhost:3306/openmrs --username=root --password=password "
COMMON_CLASSPATH="$1/<%= openmrs_war_file_name %>.war"

java  $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$2/<%= bahmni_core %>.omod:$COMMON_CLASSPATH --changeLogFile=migrations/dependent-modules/liquibase.xml $CREDS update

java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$2/<%= openmrs_atomfeed %>.omod:$COMMON_CLASSPATH --changeLogFile=liquibase.xml $CREDS update
java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$2/<%= openmrs_appframework %>.omod:$COMMON_CLASSPATH --changeLogFile=liquibase.xml $CREDS update
java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$2/<%= openmrs_calculation %>.omod:$COMMON_CLASSPATH --changeLogFile=liquibase.xml $CREDS update
java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$2/<%= openmrs_metadatamapping %>.omod:$COMMON_CLASSPATH --changeLogFile=liquibase.xml $CREDS update
java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$2/<%= openmrs_providermanagement %>.omod:$COMMON_CLASSPATH --changeLogFile=liquibase.xml $CREDS update
java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$2/<%= openmrs_uiframework %>.omod:$COMMON_CLASSPATH --changeLogFile=liquibase.xml $CREDS update
java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$2/<%= bahmni_elisatomfeedclient %>.omod:$COMMON_CLASSPATH --changeLogFile=liquibase.xml $CREDS update
java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$2/<%= bahmni_openerpatomfeedclient %>.omod:$COMMON_CLASSPATH --changeLogFile=liquibase.xml $CREDS update


java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$2/<%= bahmni_core %>.omod:$COMMON_CLASSPATH --changeLogFile=liquibase.xml $CREDS update

java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$3/<%= bahmni_apps %>.omod:$COMMON_CLASSPATH --changeLogFile=liquibase.xml $CREDS update

java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=<%= temp_dir%>/<%= bahmni_elisatomfeedclient %>/lib/<%= atomfeed_client %>.jar:$COMMON_CLASSPATH --changeLogFile=sql/db_migrations.xml $CREDS update  -DschemaName=openmrs 