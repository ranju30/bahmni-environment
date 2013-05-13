# Make sure the box file is in the folder
vagrant plugin install vagrant-vbguest
cp setup/vagrant* ~/.ssh/
vagrant up
ssh -t root@192.168.33.10 'cp -r /home/vagrant/.ssh . && mkdir /packages'


rsync -rh --progress -i --itemize-changes --ignore-existing --delete --perms packages -e ssh root@192.168.33.10:/
# yum -y install yum-utils.noarch
# yumdownloader --resolve 