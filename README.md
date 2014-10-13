# eycap-vagrant

Welcome to the ``eycap-vagrant`` project.  Vagrant helps to make many things possible by virtualizing hardware.  And by creating a virtual environment we can do integration tests for ``eycap``, Vagrant will help us to better test and ensure that the recipes we've written work well for our systems.

## Requriements

Please download and run the following installers for your specific operating system:

* [Vagrant](http://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Chef DK](http://downloads.getchef.com/chef-dk/)

### Check out the repo

    git clone git@github.com:engineyard/eycap-vagrant.git

Run ``bundle install`` to install the gems you'll need.

```
bundle install
```

Then run ``berks install`` to install the cookbooks you'll need.

```
berks install
```

### Start the virtual server

Use ``vagrant up`` to start the virtual server.

```
vagrant up
```


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

Generate a password with this command, replacing `plaintextpassword` with your password:

```
openssl passwd -1 "plaintextpassword"
```

Then put your password in the JSON attribute for password:

```
"password": "$1$NqxiOhd8$U86GLy0BjTiFlRTiQBd2//",
```

Copy your public key and put it in the "ssh keys" hash 

```
cat ~/.ssh/id_rsa.pub
```

The ssh_keys goes in a double quoted string: ``""``.

```
  "ssh_keys": [ "ssh-rsa DDDDD3NzaC1yc2EAAAABIwAAAQEAuF/7aXnyBwYX6IiInJ7M1m+426HDLiCeHQYlvWvyFJ4mQRohnen1knnwERMjvxJcizn0p28wWl++h33bgMvbaDV6orzatkg1sZ4z473DOItGWLoZ97CC6erAvvjQR5qvEcZXBFzT6Bv1FXLBzwfiRBek8MSDVyCCcahc74qaqbbNBAMhKrHBRbl6/EfhRgjHrujXa1AvVG1pKH2EMDXBmdTFLj9Dab23yH/8QxMzZq8TfCfRtWLKH3epcpvX1r1lieSKTVvQGwf0F9FLWqmELV6oND+K5yLL1vKDSNz0I+M+IVQGnGb2W2Iu5rEQ0FOiZhRrmbxl3Lp9fzMCgplbiDQ== key@example.local"
  ],
```

### Prepare chef

Run ``vagrant ssh-config`` to grab the path to your ``IdentityFile``.  We'll use that in our next steps.

```bash
$ vagrant ssh-config
Host default
  HostName 127.0.0.1
  User vagrant
  Port 2222
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /Volumes/threeterrabyte/vagrant/home/insecure_private_key
  IdentitiesOnly yes
  LogLevel FATAL
```

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
