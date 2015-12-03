#!/bin/bash

ping -q -c2 google.com > /dev/null
if [ $? -ne 0 ]
then
    echo "Starting Wvdial......"
    sudo wvidal &
fi

sudo service openerp status
if [ $? -ne 0 ]
then
    echo "Starting Openerp ...."
    sudo service openerp start
fi

sudo service tomcat status | grep "running with pid"
if [ $? -ne 0 ]
then
    echo "Starting Tomcat ...."
    sudo service tomcat start
fi

