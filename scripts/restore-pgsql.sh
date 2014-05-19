#!/bin/sh
set -e -x
dumpfile=$1

if [ -z $dumpfile ]; then
	echo "Please specify sql dump file"
	exit 1
fi	

psql -Upostgres -c "drop database if exists openerp;";
psql -Upostgres -c "drop database if exists lab;";
psql -Upostgres -c "drop database if exists clinlims;";
psql -Upostgres -c "drop database if exists reference_data;";
psql -Upostgres < $1
