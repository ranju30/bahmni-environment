#!/usr/bin/env bash

sudo rm -rf "<%= @oviyam2_webapp_location %>"
unzip -o -q "<%= build_output_dir %>/<%= oviyam2_war_filename %>.war" -d "<%= oviyam2_webapp_location %>"