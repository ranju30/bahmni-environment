#!/bin/sh
set -e -x

CHANGE_LOG_TABLE="-Dliquibase.databaseChangeLogTableName=liquibasechangelog -Dliquibase.databaseChangeLogLockTableName=liquibasechangeloglock"
LIQUIBASE_JAR="openmrs/WEB-INF/lib/liquibase-core-2.0.5.jar"
DRIVER="com.mysql.jdbc.Driver"
CREDS="--url=jdbc:mysql://localhost:3306/openmrs --username=root --password=password"
COMMON_CLASSPATH="$1/<%= openmrs_war_file_name %>.war"

java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$COMMON_CLASSPATH --changeLogFile=liquibase-schema-only.xml $CREDS update
java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$COMMON_CLASSPATH --changeLogFile=liquibase-core-data.xml $CREDS update
java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$COMMON_CLASSPATH --changeLogFile=liquibase-update-to-latest.xml $CREDS update
java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=openmrs/WEB-INF/bundledModules/logic-0.5.2.omod:$COMMON_CLASSPATH --changeLogFile=liquibase.xml $CREDS update