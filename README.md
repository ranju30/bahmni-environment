virtual box and vagrant tips
----------------------------
1. Ensure you have 4.2.* version of virtual box and 1.2.* of vagrant
2. To get the vagrant ssh command to connect without asking for password - copy https://github.com/mitchellh/vagrant/blob/master/keys/vagrant.pub to VM's /root/.ssh/authorized_keys file.
3. If your vm is unable to get network interfaces setup correctly, then go to the VM and comment out (or remove) all the entries in /etc/udev/rules.d/70-persistent-net.rules file. After doing this reload your VM.
4. If you are using port forwarding and using any of the forwarded ports on your host machine, your vagrant boot can hang.
