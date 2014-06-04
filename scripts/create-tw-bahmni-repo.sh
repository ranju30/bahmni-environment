#!/bin/bash

PATH_OF_CURRENT_SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sudo cp $PATH_OF_CURRENT_SCRIPT/tw-bahmni.repo /etc/yum.repos.d/