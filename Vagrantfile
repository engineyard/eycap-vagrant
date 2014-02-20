# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Use a gentoo base box
  # config.vm.box     = "gentoo"
  # config.vm.box_url = "https://dl.dropboxusercontent.com/s/qubuaqiizvfpsyx/gentoo-20131024-amd64.box"
  
  # Would like to ask a gentoo expert about this:
  # https://www.evernote.com/shard/s238/sh/e99b1bcc-8d26-4de0-8a7b-98cdc015bacf/47e4300f034cff41812a9ac61511151e

  # Use a ubuntu base box
  config.vm.box = "precise64.4"
  # config.vm.box_url = "package"

  # Go faster stripes
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 2048]
    v.customize ["modifyvm", :id, "--cpus", 2]
  end

  # Private network
  config.vm.network "private_network", ip: "33.33.33.10"

  # Install ruby 2.1.0
  # config.vm.provision "shell", inline: "wget -q -O - https://gist.github.com/7hunderbird/60d984cd922c5a379d3f/raw | bash"

  # Chef provisioning
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "chef/cookbooks"
    chef.add_recipe "build-essential"
    chef.add_recipe "git"

#    chef.add_recipe "apt"
#    chef.add_recipe "bluepill"
    chef.add_recipe "monit_bin"
#    chef.add_recipe "mysql"
    chef.add_recipe "nginx"
#    chef.add_recipe "ohai"
    chef.add_recipe "openssl"
#    chef.add_recipe "ruby_build"
#    chef.add_recipe "runit"
#    chef.add_recipe "rsyslog"
#    chef.add_recipe "yum"
    chef.add_recipe "main"
  end

end
