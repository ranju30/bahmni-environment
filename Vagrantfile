# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bahmni-complete"
  config.vm.box_url = "centos-6.2-64bit-puppet-vbox.4.1.8-11.box"
  # config.vm.boot_mode = :gui
  # config.vm.network :hostonly, "192.168.33.10"
  # config.vm.network :public_network
  # config.ssh.username = "root"


  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 1024]
  end
  
  config.vm.synced_folder "packages", "/packages", :owner => "root"
  config.vm.network :forwarded_port, host: 8153, guest: 8153
  config.vm.network :forwarded_port, host: 8080, guest: 8080

  # config.vm.share_folder "v-data", "/vagrant_data", "../data"

  if ENV['STAGE'] == nil
    manifest_file = "do-nothing.pp"
  else
    manifest_file = ENV['STAGE'] + ".pp"
  end
  
  config.vm.provision :puppet do |puppet|
    #puppet.pp_path="/vagrant-temp/vagrant-puppet"
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = manifest_file
    puppet.module_path = "puppet/modules"
    #puppet.options = "--noop "
    #puppet.options = "--verbose --debug --noop --graph  --graphdir /vagrant/graphs"
    # sample command to run puppet directly 
    # puppet apply --graph --graphdir /vagrant/graphs -v -l /tmp/manifest.log --modulepath modules manifests/cisetup.pp
  end
end