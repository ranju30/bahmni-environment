# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "bahmni-complete"
  config.vm.box_url = "centos-6.2-64bit-puppet-vbox.4.1.8-11.box"
  # config.vm.boot_mode = :gui
  # config.vm.network :hostonly, "192.168.33.10"
  # config.vm.network :bridged
  # config.ssh.username = "root"
  config.vm.customize ["modifyvm", :id, "--memory", 1024]

  config.vm.share_folder "packages", "/packages", "packages", :owner => "root"
  config.vm.forward_port 8153, 8153

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
    #puppet.options = "--verbose --debug --noop"
  end
end