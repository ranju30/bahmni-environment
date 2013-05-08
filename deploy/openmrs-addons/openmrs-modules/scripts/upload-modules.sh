#!/bin/bash

check_args() {
	if [ $# -lt 2 ]; then
	   echo "Usage: $0 admin-password modules"
		 echo "Default OPENMRS_URL is http://localhost:8080/openmrs"
	   exit 1
	fi	
}

assign_defaults () {
	if [ -z $OPENMRS_URL ]; then 
		OPENMRS_URL='http://localhost:8080/openmrs'
	fi	
}

login() {
	curl -isS -c /tmp/cookie.txt -d uname=admin -d pw=${1} $OPENMRS_URL/loginServlet > /tmp/login_response.txt
	check_if_login_success_full	
}

upload_from_local_file(){
	OMOD_FILE=$1
	if ! [ -f $OMOD_FILE ]; then
	   echo Error: module file $OMOD_FILE does not exist
	   exit 1
	fi

	curl -isS -b /tmp/cookie.txt -F action=upload -F update=true -F moduleFile=\@$OMOD_FILE $OPENMRS_URL/admin/modules/module.list > /tmp/upload_response.txt	

}

check_if_upload_success_full() {
	if  ! grep -q "modules/module.list" "/tmp/upload_response.txt"; then
		echo "Failed to update module $1. Please check /tmp/upload_response.txt and /tmp/login_response.txt for more info"
		exit 1
	fi	
}

check_if_login_success_full() {
	if grep -q "login.htm" "/tmp/login_response.txt"; then
		echo "Failed to login as openmrs user 'admin'. Please verify the admin password. Check /tmp/login_response.txt for more info"
		exit 1
	fi	
}

upload_from_http_url(){
	curl -isS -b /tmp/cookie.txt -F action=upload -F download=true -F downloadURL=$1 $OPENMRS_URL/admin/modules/module.list > /tmp/upload_response.txt	
}

upload_module() {	
	echo "Uploading module $1"
	if [[ $1 =~ http:.* ]];	then
	   upload_from_http_url $1
	else
	   upload_from_local_file $1		
	fi
	check_if_upload_success_full $1
}


cleanup() {
	rm -rf /tmp/cookie.txt /tmp/login_response.txt /tmp/upload_response.txt > /dev/null 2>&1	
}

upload_modules() {
	for module in $@
	do
		upload_module $module
	done	
}

_main_() {
	set -e

	check_args $@
	assign_defaults
	login $1
	shift
	upload_modules $@
	cleanup
}

_main_ $@



