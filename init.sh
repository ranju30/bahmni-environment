# Make sure the box file is in the folder
vagrant plugin install vagrant-vbguest
cp setup/vagrant* ~/.ssh/
vagrant up
ssh -t root@$1 'cp -r /home/vagrant/.ssh . && mkdir /packages'


# yum -y install yum-utils.noarch
# yumdownloader --resolve 