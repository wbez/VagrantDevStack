# Vagrant Dev Stack
This is a collection of a Vagrant file, plugin requirements, Puppet manifest and modules assembled to make launching a dev stack locally as painless as possible.

# Requirements
- Vagrant http://www.vagrantup.com/downloads.html
- VirtualBox https://www.virtualbox.org/wiki/Downloads

# Usage
1. Install Vagrant and VirtualBox software.
1. Clone project to sub-directory using `scripts/create_dev_environment.sh`
  * Script takes one argument: the name of the folder into which you're cloning the project  To create a new clone for chicagopublicmedia.org, run `scripts/create_dev_environment.sh chicagopublicmedia.org`.  This will result in a blank Vagrant setup in a folder named 'chicagopublicmedia.org' inside the current directory.
1. Configure Vagrant file
  * `client_key` When suffixed with '.local', determines the hostname created for this VM.  For example, setting `client_key` to 'wbez' will assign this VM the hostname 'wbez.local' in your /etc/hosts file. If the `project_base` that you're using requires a database, the `client_key` also becomes the username, password, and name of the initial database.  The `client_key` must be less than 16 characters so it can be used as a database username.
  * `project_base` The kind of app that will be running on this Vagrant.  Current options are:
    * (empty): Will only install git and Apache
    * `drupal`: Installs database, PHP, drush and other Drupal-required packages.
1. Run `vagrant up` to launch vm. _Password requests during launch refer to your local admin account password, to allow modification of network settings._

# Notes
* Setting up `ssh-agent` on your host machine allows you to use any of the SSH keys on your local machine from within the Vagrant VM without having to map any drives or copy files.