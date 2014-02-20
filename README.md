# eycap-vagrant

Welcome to the ``eycap-vagrant`` project.  We aim to make testing eycap quick and painless.

## Requriements

[Download Vagrant](http://www.vagrantup.com/downloads.html)

[Download VirtualBox](https://www.virtualbox.org/wiki/Downloads)

Check out this repo:

    git clone git@github.com:engineyard/eycap-vagrant.git

Review the ``Vagrantfile`` for options, when ready run ``vagrant up`` to start server(s).

Use ``capistrano`` and ``eycap`` to deploy and test deploying to local virtual servers.

## GuestAdditions Don't Match

You may see a yellow warning when starting your server: 

    [default] The guest additions on this VM do not match the installed version of
    VirtualBox! In most cases this is fine, but in rare cases it can
    prevent things such as shared folders from working properly. If you see
    shared folder errors, please make sure the guest additions within the
    virtual machine match the version of VirtualBox you have installed on
    your host and reload your VM.

    Guest Additions Version: 4.2.0
    VirtualBox Version: 4.3

You can optionally install the vagrant plugin called ``vagrant-vbguest`` which will automatically detect and install the version of your VirtualBox's guest additions.

    vagrant plugin install vagrant-vbguest

And all you need to do is shut down and boot up and the plugin should do the rest.  Although the first time I did this it recommended I skip the provisioner.

    vagrant up --no-provision

You may get an warning like this after it's done installing: "An error occurred during installation of VirtualBox Guest Additions 4.3.6. Some functionality may not work as intended.  In most cases it is OK that the "Window System drivers" installation failed."

That's ok, it worked for me.  Just reboot your box(es) and be back up with Guest Additions in sync with your version.

    vagrant up --provision