#!/bin/sh
set -e -x


CHANGE_LOG_TABLE="-Dliquibase.databaseChangeLogTableName=liquibasechangelog -Dliquibase.databaseChangeLogLockTableName=liquibasechangeloglock"
LIQUIBASE_JAR="$1/openmrs/WEB-INF/lib/liquibase-core-2.0.5.jar"
DRIVER="com.mysql.jdbc.Driver"
CREDS="--url=jdbc:mysql://localhost:3306/openmrs --username=root --password=password"
CLASSPATH="$2/<%= openmrs_war_file_name %>.war"

java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRVIER --classpath=$CLASSPATH --changeLogFile=liquibase.xml $CREDS update