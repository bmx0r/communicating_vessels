# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
    config.vm.box = "minimal-centos-60"
    config.vm.host_name = "scanner"
    config.vm.network :hostonly, "192.168.1.10"
    config.vm.share_folder "puppet-files", "/etc/puppet/files", "./files"
    config.vm.forward_port 9392, 9292 # OPENVAS
  
    config.vm.provision :puppet do |puppet|
    puppet.module_path = "./modules"
    puppet.manifests_path = "./manifests"
    puppet.manifest_file = "init.pp"
    puppet.options = ["--fileserverconfig=/vagrant/fileserver.conf", "--verbose", "--debug" ]
  end
end
