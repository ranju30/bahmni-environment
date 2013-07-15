#!/bin/bash

set -e -x 

SCRIPTS_DIR=`dirname $0`
BASE_DIR=$SCRIPTS_DIR/..
FACTER_module_name="$1" puppet apply $BASE_DIR/puppet/manifests/run.pp  --modulepath=$BASE_DIR/puppet/modules/