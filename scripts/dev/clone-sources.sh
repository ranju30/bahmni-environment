#!/bin/bash

absolute_path_to_folder_containing_all_source_folders=$1

function echoerr { 
  echo "$@" 1>&2; 
}

function usage {
    echoerr "Invalid syntax. Expected clone-repos folder-to-clone-into";
}

function clone_sources {
  while read source; do
    repo_url=`echo $source | awk -F " " '{print $1}'`
    echo "*********************************************************************************************************"
    echo "Cloning $repo_url"
    output_folder_name=$absolute_path_to_folder_containing_all_source_folders`echo $source | awk -F " " '{print $2}'`
    if [[ ! -e $output_folder_name  ]]; then
        git clone $repo_url $output_folder_name
    else
    	echo "The path $output_folder_name exists. Hence not cloning"
    fi
    echo "*********************************************************************************************************"
  done < ./source.list
}

if [ $# -ne 1 ]; then
  usage
else
  clone_sources
fi

