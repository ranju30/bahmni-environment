#!/bin/bash

    $(mysql --user=root --password=$1 --database=openmrs --execute="select count(*) from patient;")