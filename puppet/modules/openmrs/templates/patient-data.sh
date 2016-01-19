#!/bin/bash

    (mysql --user=root --password=password --database=openmrs --execute="select count(*) from patient;")