# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "bahmni-complete"
  config.vm.box_url = "centos-6.2-64bit-puppet-vbox.4.1.8-11.box"
  # config.vm.boot_mode = :gui
  # config.vm.network :hostonly, "192.168.33.10"
  config.vm.network :bridged
  config.ssh.username = "root"
  config.vm.customize ["modifyvm", :id, "--memory", 1024]
  # config.vm.forward_port 80, 8080
  # config.vm.share_folder "v-data", "/vagrant_data", "../data"

  stages = {'provision' => "provision.pp", 'deploy' => 'deploy.pp'}
  manifest_file = stages[ENV['STAGE']]
  manifest_file = "do-nothing.pp" if manifest_file.nil?

  config.vm.provision :puppet do |puppet|
    puppet.pp_path="/vagrant-temp/vagrant-puppet"
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = manifest_file
    puppet.module_path = "puppet/modules"
  end
end