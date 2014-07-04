#!/bin/sh
set -e -x

service openerp start
service tomcat start
service httpd start