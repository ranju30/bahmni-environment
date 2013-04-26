# Make sure the box file is in the folder
vagrant plugin install vagrant-vbguest
cp setup/vagrant* ~/.ssh/
vagrant up
ssh -t root@192.168.33.10 'cp -r /home/vagrant/.ssh .'