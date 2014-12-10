#!/bin/sh
# Ideally everything should be installed via puppet but for puppet to run certain utilities need to be installed for puppet to run
sudo yum install ruby
sudo rpm -ivh http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm
sudo yum install puppet
echo 'export IMPLEMENTATION_NAME=$1' >> ~/.bashrc
mkdir /packages
mkdir /packages/tools
mkdir /packages/servers
wget -r -nH --no-parent --reject="index.html*" https://bahmni-repo.twhosted.com/tools/ -P /packages
wget -r -nH --no-parent --reject="index.html*" https://bahmni-repo.twhosted.com/servers/ -P /packages