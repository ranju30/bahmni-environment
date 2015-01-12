# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bahmni-complete-environment"
  config.vm.box_url = "bahmni.box"
  # config.vm.boot_mode = :gui

#  config.vm.network :forwarded_port, guest: 8080, host: 8081
#  config.vm.network :forwarded_port, guest: 443, host: 8082
#  config.vm.network :forwarded_port, guest: 80, host: 8083
  config.vm.network :private_network, ip: "192.168.33.10"
#  config.vm.network :public_network
  config.ssh.username = "vagrant"

  config.vm.provider "virtualbox" do |v|
     v.customize ["modifyvm", :id, "--memory", 3092, "--cpus", 2, "--name", "Bahmni"]
  end

#  config.vm.synced_folder "packages", "/packages", :owner => "vagrant"
  config.vm.synced_folder ".", "/bahmni-environment", :owner => "vagrant"

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
