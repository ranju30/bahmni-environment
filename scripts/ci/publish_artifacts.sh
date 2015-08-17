#!/usr/bin/env bash

version=$1

TIME=`date +%Y%m%d_%H%M%S`

ARTIFACTS_PATH="/root/Dropbox/"

sudo mkdir -p $ARTIFACTS_PATH
sudo chmod 777 -R $ARTIFACTS_PATH

cp -rf release_${version}/ $ARTIFACTS_PATH