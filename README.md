# eycap-vagrant

Welcome to the ``eycap-vagrant`` project.  Vagrant helps to make many things possible by virtualizing hardware.  And by creating a virtual environment we can do integration tests for ``eycap``, Vagrant will help us to better test and ensure that the recipes we've written work well for our systems.

## Requriements

[Download Vagrant](http://www.vagrantup.com/downloads.html)

[Download VirtualBox](https://www.virtualbox.org/wiki/Downloads)

### Check out the repo

    git clone git@github.com:engineyard/eycap-vagrant.git

Run ``bundle install`` to install the gems you'll need.

Then run ``berks install`` to install the cookbooks you'll need.

### Start the virtual server

Use ``vagrant up`` to start the virtual server.


### Set up the deploy and vagrant users

```bash
cp data_bags/users/deploy.json.example data_bags/users/deploy.json
```

By copying this file you'll be able next to setup the deploy user that will be created on the server.  Because we're also using ``vagrant``, we want to do this for ``vagrant`` as well.

```bash
cp data_bags/users/deploy.json.example data_bags/users/vagrant.json
```

The reason for this, is because after chef runs, the vagrant user will be blown away, and we'll want to have it created back.

### Populate the user json files

You'll need to add the information in the ``deploy.json`` and ``vagrant.json`` files.

```json
{
  "id": "deploy",
  // generate this with: openssl passwd -1 "plaintextpassword"
  "password": "",
  // the below should contain a list of ssh public keys which should
  // be able to login as deploy
  "ssh_keys": [
  ],
  "groups": [ "sysadmin"],
  "shell": "\/bin\/bash"
}
```

The ssh_keys goes in a double quoted string: ``""``.

### Prepare chef

Run ``vagrant ssh-config`` to grab the path to your ``IdentityFile``.  We'll use that in our next steps.

To prepare chef we run the following:

```bash
bundle exec knife solo prepare vagrant@127.0.0.1 -p 2222 -i /Volumes/threeterrabyte/vagrant/home/insecure_private_key
```

We're logging in as the ``vagrant`` user on port ``2222`` and using the identity ``/Volumes/threeterrabyte/vagrant/home/insecure_private_key``.

This allows us to use SSH to connect to the vagrant server like a remote server, even though it's a local host.

And this allows us to run our chef ``knife`` commands, just like we'd run them, if we were running them on a remote server.

### Copy runlist to local node

When you run the ``knife solo prepare`` command above it generates the ``PROJECT_ROOT/nodes/127.0.0.1.json`` file.

And then it [bootstraps and installs chef](https://gist.github.com/7hunderbird/523186164e3086bf9029) on the virtual server in Vagrant, etc.

To to "cook chef" and run the cookbooks and recipes contained in this project, please do the following.

Open the ``build-essential.json`` file and copy the contents out.  Then paste them into the ``127.0.0.1.json`` file.

### Cook Chef

After you've prepared you're ready to cook.

```bash
bundle exec knife solo cook vagrant@127.0.0.1 -p 2222 -i /Volumes/threeterrabyte/vagrant/home/insecure_private_key 
```
