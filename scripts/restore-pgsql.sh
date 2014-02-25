#!/bin/sh
set -e -x
dumpfile=$1

if [ -z $dumpfile ]; then
	echo "Please specify sql dump file"
	exit 1
fi	

psql -Upostgres -c "drop database openerp;";
psql -Upostgres -c "drop database lab;";
psql -Upostgres -c "drop database clinlims;";
psql -Upostgres -c "drop database reference_data;";
psql -Upostgres < $1
