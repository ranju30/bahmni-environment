#!/bin/bash

sudo mkdir -p /usr/local/bahmni/bin
sudo mkdir -p /home/bahmni/Desktop/bahmni

sudo cp -f *.sh /usr/local/bahmni/bin/
chmod -R +x /usr/local/bahmni/bin

cp desktop/*.desktop /home/bahmni/Desktop/bahmni/
