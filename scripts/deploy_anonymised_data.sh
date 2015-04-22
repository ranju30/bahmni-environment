#!/bin/bash -x

CURR_DIR=`dirname $0`
SCRIPTS_DIR="${CURR_DIR}"
DUMP_DIR="/tmp/anonymised_dump"
mkdir -p $DUMP_DIR
rm -rf $DUMP_DIR/*

if [ -z ${FACTER_deploy_bahmni_openelis} ] || [ -z ${FACTER_deploy_bahmni_openerp} ] || [ -z ${anonymised_dump_url} ]; then
    echo "Please set all the required environment variables (FACTER_deploy_bahmni_openelis, FACTER_deploy_bahmni_openerp, anonymised_dump_url) before executing the script"
    exit 1;
fi

wget -r -nd -nH --no-parent --reject="index.html*" --no-check-certificate ${anonymised_dump_url}/ -P ${DUMP_DIR}
gunzip ${DUMP_DIR}/*.gz
if [ ! -f $DUMP_DIR/anonymised_openmrs*.sql ]; then
   echo "No openmrs dump found"
   rm -rf $DUMP_DIR/*
   exit 1
fi

if  [ ${FACTER_deploy_bahmni_openelis} == "true" ]; then
  if [ ! -f ${DUMP_DIR}/anonymised_clinlims*.sql ]; then
    echo "No openelis dump found"
    rm -rf $DUMP_DIR/*
    exit 1
  fi
fi

if [ ${FACTER_deploy_bahmni_openerp} == "true" ]; then
  if [ ! -f ${DUMP_DIR}/anonymised_openerp*.sql ]; then
    echo "No openerp dump found"
    rm -rf $DUMP_DIR/*
    exit 1
  fi
  sudo service openerp stop
fi

# we are not checking whether the above processess exit or not, bcoz the service scripts already does it
sudo service tomcat stop
mysql -uroot -ppassword -e "drop database if exists openmrs"
mysql -uroot -ppassword -e "create database openmrs"
mysql -uroot -ppassword openmrs < $DUMP_DIR/anonymised_openmrs*.sql

if [ ${FACTER_deploy_bahmni_openelis} == "true" ]; then
    psql -Upostgres -c "drop database if exists clinlims;";
    psql -Upostgres -c "create database clinlims;";
    psql -Upostgres -d clinlims < $DUMP_DIR/anonymised_clinlims*.sql
fi

if [ ${FACTER_deploy_bahmni_openerp} == "true" ]; then
    psql -Upostgres -c "drop database if exists openerp;";
    psql -Upostgres -c "create database openerp;";
    psql -Upostgres -d openerp < $DUMP_DIR/anonymised_openerp*.sql
    sudo service openerp start
fi

sudo service tomcat start
rm -rf $DUMP_DIR/*
exit 0;