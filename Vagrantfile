# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bahmni-complete-environment"
  config.vm.box_url = "bahmni.box"
  # config.vm.boot_mode = :gui

  config.vm.network :private_network, ip: "192.168.33.10"
  config.vm.network :public_network
  config.ssh.username = "root"

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 3092, "--cpus", 2, "--name", "Bahmni"]
  end

#  config.vm.synced_folder "packages", "/packages", :owner => "root"
  config.vm.synced_folder "..", "/Project", :owner => "root"
  config.vm.synced_folder "../openmrs-module-bahmniclinical/clinical-ui/app", "/var/www/clinical", :owner => "jss"
  config.vm.synced_folder "../openmrs-module-bahmniregistration/registration-ui/app", "/var/www/registration", :owner => "jss"
  config.vm.synced_folder "../openmrs-module-bahmnihome/home-ui/app", "/var/www/home", :owner => "jss"
  config.vm.synced_folder "../jss-config", "/var/www/bahmni_config", :owner => "jss"

  if ENV['STAGE'] == nil
    manifest_file = "do-nothing.pp"
  else
    manifest_file = ENV['STAGE'] + ".pp"
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = manifest_file
    puppet.module_path = "puppet/modules"
    #puppet.options = "--noop "
    #puppet.options = "--verbose --debug --noop --graph  --graphdir /vagrant/graphs"
    # sample command to run puppet directly 
    # puppet apply --graph --graphdir /vagrant/graphs -v -l /tmp/manifest.log --modulepath modules manifests/cisetup.pp
  end
end
