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

  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"


  # Go faster stripes
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 2048]
    v.customize ["modifyvm", :id, "--cpus", 2]
  end

  # Install curl
  config.vm.provision "shell", inline: "sudo apt-get install curl -y"

  # Install ruby 2.1.0
  config.vm.provision "shell", inline: "curl -L https://gist.githubusercontent.com/7hunderbird/60d984cd922c5a379d3f/raw/b087418d7da527a51ec6d960cf1dee8208e086c7/vagrant-bootstrap.sh | bash"

  # Install bundler
  config.vm.provision "shell", inline: "gem install bundler --no-ri --no-rdoc"

  # Chef provisioning
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "./cookbooks"
    chef.add_recipe "main"
  end

end
