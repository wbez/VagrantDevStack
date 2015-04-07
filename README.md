# Vagrant Dev Stack
This is a collection of a Vagrant file, plugin requirements, Puppet manifest and modules assembled to make launching a dev stack locally as painless as possible.

# Requirements
- Vagrant
- VirtualBox

# Usage
1. Install required software
1. Configure Vagrant file
  * `client_key` When suffixed with '.local', determines the hostname created for this VM.  For example, setting `client_key` to 'wbez' will assign this VM the hostname 'wbez.local' in your /etc/hosts file. If the `project_base` that you're using requires a database, the `client_key` also becomes the username, password, and name of the initial database.  The `client_key` must be less than 16 characters so it can be used as a database username.
  * `project_base` The kind of app that will be running on this Vagrant.  Current options are:
    * `drupal`.
1. Run `vagrant up`

# Notes
* Setting up `ssh-agent` on your host machine allows you to use any of the SSH keys on your local machine from within the Vagrant VM without having to map any drives or copy files.
