#!/bin/bash

set -e

export FACTER_openmrs_distro_file_name_prefix=distro-2.5-SNAPSHOT
export FACTER_openmrs_war_file_name="openmrs-webapp-1.9.7-SNAPSHOT"

`dirname $0`/deploy-puppet-manifest.sh $@