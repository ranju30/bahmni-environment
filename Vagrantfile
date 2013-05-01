# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "bahmni-complete"
  config.vm.box_url = "centos-6.2-64bit-puppet-vbox.4.1.8-11.box"
  # config.vm.boot_mode = :gui
  config.vm.network :hostonly, "192.168.33.10"
  config.ssh.username = "root"
  # config.vm.forward_port 80, 8080
  # config.vm.share_folder "v-data", "/vagrant_data", "../data"

  stages = {'provision' => "provision.pp", 'deploy' => 'deploy.pp'}
  stage = stages[ENV['STAGE']]
  
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = stage
    puppet.module_path = "puppet/modules"
  end
end