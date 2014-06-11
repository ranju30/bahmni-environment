Bahmni Environment
===================
[![Build Status](https://travis-ci.org/Bhamni/bahmni-environment.svg?branch=master)](https://travis-ci.org/Bhamni/bahmni-environment)

This repo contains puppet scripts and other utilities for setting up Bahmni on Dev or Production environment.


Bahmni BOX Setup Steps
-------------------------
See this file: [Box Setup Steps](https://github.com/Bhamni/bahmni-environment/blob/master/bahmni_box_setup_steps.txt)

Virtual box and vagrant tips
----------------------------
1. Ensure you have 4.2.* version of virtual box and 1.2.* of vagrant
2. To get the vagrant ssh command to connect without asking for password - copy https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub to VM's /root/.ssh/authorized_keys file. Make sure that the contents are copied exactly or just use wget. If is likely that the vagrant up command hangs because of this. Also copy the vagrant's private key to your machine ~/.ssh/ folder, from here https://raw.github.com/mitchellh/vagrant/master/keys/vagrant. Keep in mind that this makes your vm insecure, so do not keep anything personal on your VM.
3. If your vm is unable to get network interfaces setup correctly, then go to the VM and comment out (removing wouldn't do) all the entries in /etc/udev/rules.d/70-persistent-net.rules file. After doing this reload your VM.
4. If you are using port forwarding and using any of the forwarded ports on your host machine, your vagrant boot can hang.
5. VAGRANT_LOG=info vagrant <command> provides useful insights incase you get stuck.
6. If your eth1 and eth2 on your VM still (even after following step 3) doesn't come up, you might be better off replacing /etc/sysconfig/network-scripts/ifcfg-eth1 and /etc/sysconfig/network-scripts/ifcfg-eth2 files on your VM with these respectively - https://raw.github.com/Bhamni/bahmni-environment/master/samples/virtualbox-vargant/ifcfg-eth1 and https://raw.github.com/Bhamni/bahmni-environment/master/samples/virtualbox-vargant/ifcfg-eth2 respectively. You can use wget.
7. Keep the vagrant plugins uptodate using vagrant plugin ... commands.
8. If you are getting error related to guest additions even after you do reload then, you need to update your plugins. For example like this: vagrant plugin update vagrant-vbguest . Failure to load the guest addons can result in puppet folders not being shared between the guest and host.
9. If you want to do ssh into the VM (this is different from being able to do vagrant ssh into the VM) without having to provide password, copy your public key content (in ~/.ssh/) to the VMs ~/.ssh/authorized_keys file.
10. If you get an error like 'Nonexistent host networking vboxnet0', try restartying VirtualBox. Mac command -> sudo /Library/StartupItems/VirtualBox/VirtualBox restart. 

Commands
--------
rm /etc/udev/rules.d/70-persistent-net.rules
wget https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub --no-check-certificate
mv vagrant.pub .ssh/authorized_keys
vagrant plugin update vagrant-vbguest