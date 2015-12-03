#!/bin/bash

source ~/.bashrc
BAHMNI_SCRIPTS=/usr/local/bahmni/bin

if [ "$FACTER_deploy_passive" = "false" ]
then
    sudo $BAHMNI_SCRIPTS/bahmni_active.sh $1
else
    sudo $BAHMNI_SCRIPTS/bahmni_passive.sh $1
fi