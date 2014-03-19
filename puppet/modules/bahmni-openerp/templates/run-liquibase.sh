#!/bin/sh
set -e -x


CHANGE_LOG_TABLE="-Dliquibase.databaseChangeLogTableName=liquibasechangelog -Dliquibase.databaseChangeLogLockTableName=liquibasechangeloglock"
LIQUIBASE_JAR="<%= tomcatInstallationDirectory %>/webapps/<%= openerp_atomfeed_war_file_name %>/WEB-INF/lib/liquibase-core-2.0.3.jar"
DRIVER="org.postgresql.Driver"
CREDS="--url=jdbc:postgresql://localhost:5432/openerp --username=postgres --password=postgres"
CLASSPATH="$1/<%= openerp_atomfeed_war_file_name %>.war"
CHANGE_LOG_FILE="<%= tomcatInstallationDirectory %>/webapps/<%= openerp_atomfeed_war_file_name %>/WEB-INF/classes/sql/db_migrations.xml"

java $CHANGE_LOG_TABLE  -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$CLASSPATH --changeLogFile=$CHANGE_LOG_FILE $CREDS update