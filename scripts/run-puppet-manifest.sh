#!/bin/bash

set -e -x 

SCRIPTS_DIR=`dirname $0`
BASE_DIR=$SCRIPTS_DIR/..
puppet apply $BASE_DIR/puppet/manifests/$1.pp --modulepath=$BASE_DIR/puppet/modules/