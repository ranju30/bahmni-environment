virtual box and vagrant tips
----------------------------
1. Ensure you have 4.2.* version of virtual box and 1.2.* of vagrant
2. To get the vagrant ssh command to connect without asking for password - copy https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub to VM's /root/.ssh/authorized_keys file. Make sure that the contents are copied exactly or just use wget. If is likely that the vagrant up command hangs because of this.
3. If your vm is unable to get network interfaces setup correctly, then go to the VM and comment out (removing wouldn't do) all the entries in /etc/udev/rules.d/70-persistent-net.rules file. After doing this reload your VM.
4. If you are using port forwarding and using any of the forwarded ports on your host machine, your vagrant boot can hang.
5. VAGRANT_LOG=info vagrant <command> provides useful insights incase you get stuck.
6. If your eth1 and eth2 on your VM still (even after following step 3) doesn't come up, you might be better off replacing /etc/sysconfig/network-scripts/ifcfg-eth1 and /etc/sysconfig/network-scripts/ifcfg-eth2 files on your VM with these respectively - https://raw.github.com/Bhamni/bahmni-environment/master/samples/virtualbox-vargant/ifcfg-eth1 and https://raw.github.com/Bhamni/bahmni-environment/master/samples/virtualbox-vargant/ifcfg-eth2 respectively. You can use wget.
7. Keep the vagrant plugins uptodate using vagrant plugin ... commands.
