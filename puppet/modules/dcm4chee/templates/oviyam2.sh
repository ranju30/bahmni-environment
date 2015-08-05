#!/usr/bin/env bash

sudo unzip -o -q "<%= @build_output_dir %>/<%= @oviyam2_bin_foldername %>.zip" -d "<%= @build_output_dir %>"
sudo \cp "<%= @build_output_dir %>/<%= @oviyam2_bin_foldername %>/<%= @oviyam2_bin_foldername %>/<%= @oviyam2_war_filename %>.war" "<%= @dcm4chee_server_default_location %>/deploy"
