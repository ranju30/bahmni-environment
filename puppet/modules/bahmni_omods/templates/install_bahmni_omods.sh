#!/bin/sh

rm -rf "<%= @openmrs_modules_dir %>"/*

if test "<%= bahmni_appointments_required %>" == true;
then
    echo "Installing openmrs modules including the Appointments related modules."
    find "<%= build_output_dir %>"/"<%= openmrs_distro_file_name_prefix %>" -type f -not -regex '.*atomfeed.*client.*\.omod' | grep .omod | xargs -I file cp file "<%= openmrs_modules_dir %>"
else
    echo "Installing openmrs modules excluding the Appointments related modules."
	find "<%= build_output_dir %>"/"<%= openmrs_distro_file_name_prefix %>" -type f -not -regex '\(.*/appointmentscheduling.*\.omod\|.*/appointmentschedulingui.*\.omod\|.*/coreapps.*\.omod\|.*/htmlformentry.*\.omod\|.*/reportingrest.*\.omod\|.*/referenceapplication.*\.omod\|.*/appui.*\.omod\|.*/htmlformentryui.*\.mod\|.*atomfeed.*client.*\.omod\)' | grep .omod | xargs -I file cp file "<%= openmrs_modules_dir %>"
fi