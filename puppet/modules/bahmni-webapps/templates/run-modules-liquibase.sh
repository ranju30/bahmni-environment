#!/bin/sh
set -e -x
#start up  - to be run before all modules

WEBAPPS_DIR="<%= @tomcatInstallationDirectory %>/webapps"
OPENMRS_MODULE_DIR="<%= @openmrs_modules_dir %>"
CHANGE_LOG_TABLE="-Dliquibase.databaseChangeLogTableName=liquibasechangelog -Dliquibase.databaseChangeLogLockTableName=liquibasechangeloglock"
LIQUIBASE_JAR="openmrs/WEB-INF/lib/liquibase-core-2.0.5.jar"
DRIVER="com.mysql.jdbc.Driver"
CREDS="--url=jdbc:mysql://localhost:3306/openmrs --username=root --password=password "
COMMON_CLASSPATH="<%= @build_output_dir %>/<%= @openmrs_distro_file_name_prefix %>/<%= @openmrs_war_file_name %>.war"


cd $WEBAPPS_DIR

java  $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$OPENMRS_MODULE_DIR/<%= @bahmni_core %>.omod:$COMMON_CLASSPATH --changeLogFile=migrations/dependent-modules/liquibase.xml $CREDS update

java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$OPENMRS_MODULE_DIR/<%= @openmrs_atomfeed %>.omod:$COMMON_CLASSPATH --changeLogFile=liquibase.xml $CREDS update
java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$OPENMRS_MODULE_DIR/<%= @openmrs_appframework %>.omod:$COMMON_CLASSPATH --changeLogFile=liquibase.xml $CREDS update
java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$OPENMRS_MODULE_DIR/<%= @openmrs_calculation %>.omod:$COMMON_CLASSPATH --changeLogFile=liquibase.xml $CREDS update
java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$OPENMRS_MODULE_DIR/<%= @openmrs_metadatamapping %>.omod:$COMMON_CLASSPATH --changeLogFile=liquibase.xml $CREDS update
java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$OPENMRS_MODULE_DIR/<%= @openmrs_providermanagement %>.omod:$COMMON_CLASSPATH --changeLogFile=liquibase.xml $CREDS update
java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$OPENMRS_MODULE_DIR/<%= @openmrs_uiframework %>.omod:$COMMON_CLASSPATH --changeLogFile=liquibase.xml $CREDS update
java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$OPENMRS_MODULE_DIR/<%= @bahmni_elisatomfeedclient %>.omod:$COMMON_CLASSPATH --changeLogFile=liquibase.xml $CREDS update
java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$OPENMRS_MODULE_DIR/<%= @bahmni_openerpatomfeedclient %>.omod:$COMMON_CLASSPATH --changeLogFile=liquibase.xml $CREDS update


java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$OPENMRS_MODULE_DIR/<%= @bahmni_core %>.omod:$COMMON_CLASSPATH --changeLogFile=liquibase.xml $CREDS update

java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=<%= @ui_modules_dir %>/<%= @bahmni_apps %>.omod:$COMMON_CLASSPATH --changeLogFile=liquibase.xml $CREDS update

java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=<%= @temp_dir%>/<%= @bahmni_elisatomfeedclient %>/lib/<%= @atomfeed_client %>.jar:$COMMON_CLASSPATH --changeLogFile=sql/db_migrations.xml $CREDS update  -DschemaName=openmrs 

cd -