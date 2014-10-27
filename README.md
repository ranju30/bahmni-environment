# Bahmni Environment
[![Build Status](https://travis-ci.org/Bhamni/bahmni-environment.svg?branch=master)](https://travis-ci.org/Bhamni/bahmni-environment)

This repo contains puppet scripts and other utilities for setting up Bahmni on Dev or Production environment.


## Installing Bahmni on a CentOS Minimal System
See this file: [Box Setup Steps](bahmni_box_setup_steps.md)


## Using vagrant box which already has bahmni
* Install [virtual box](https://www.virtualbox.org/wiki/Downloads) and [vagrant](https://www.vagrantup.com/downloads.html)
* Run `git clone git@github.com:Bhamni/bahmni-environment.git && cd bahmni-environment`
* Copy the .box file to `bahmni-environment` folder and rename it as `bahmni.box`
* Run `vagrant up`
* If you will get error related to eth2, Run `scripts/dev/vagrant-network-fix.sh && vagrant reload`
* You can access the apps on
	* https://192.168.33.10/bahmni/home
	* https://192.168.33.10/openmrs
	* https://192.168.33.10/openelis
	* http://192.168.33.10:8069

## Virtual box and Vagrant troubleshooting and tips

* To use vagrant ssh as root user. Login to vagrant as root and run
```
wget https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub --no-check-certificate /tmp/vagrant.pub
cat /tmp/vagrant.pub >> ~/.ssh/authorized_keys
```			
* If you are using port forwarding and using any of the forwarded ports on your host machine, your vagrant boot can hang.
* VAGRANT_LOG=info vagrant <command> provides useful insights incase you get stuck.
* If you are getting error related to guest additions even after you do reload then, you need to update your plugins. For example like this: vagrant plugin update vagrant-vbguest . Failure to load the guest addons can result in puppet folders not being shared between the guest and host.
* Keep the vagrant plugins uptodate
```
vagrant plugin update vagrant-vbguest
```

* If you get an error like 'Nonexistent host networking vboxnet0', try restartying VirtualBox. Mac -> `sudo /Library/StartupItems/VirtualBox/VirtualBox restart`
* http://stackoverflow.com/questions/9434313/how-do-i-associate-a-vagrant-project-directory-with-an-existing-virtualbox-vm
