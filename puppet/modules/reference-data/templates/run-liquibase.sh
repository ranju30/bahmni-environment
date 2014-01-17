#!/bin/sh
set -e -x

java -Dliquibase.databaseChangeLogTableName=databasechangelog -Dliquibase.databaseChangeLogLockTableName=databasechangeloglock -jar reference-data/WEB-INF/lib/liquibase-core-3.0.5.jar --driver=org.postgresql.Driver --classpath=<%=reference_data_war%> --changeLogFile=./reference-data/WEB-INF/changelog.xml --url=jdbc:postgresql://localhost/reference_data --username=reference_data --password=reference_data update