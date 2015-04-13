# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# Install required Vagrant plugins
#
# vagrant-auto_network
# vagrant-hostsupdater
REQUIRED_PLUGINS = %w(vagrant-auto_network vagrant-hostsupdater)
exit unless REQUIRED_PLUGINS.all? do |plugin|
  Vagrant.has_plugin?(plugin) || (
    puts "The #{plugin} plugin is required. Please install it with:"
    puts "$ sudo vagrant plugin install #{plugin}"
    false
  )
end

# Client Key:  This determines the hostname created for this VM.
# For example, setting this to 'wbez' will assign this
# VM the hostname 'wbez.local'
#
# For project bases that use databases, the client key also becomes
# the username, password, and name of the initial database
# NOTE: Must be less than 16 characters so it can be used as a
# database username

client_key = "vagrant"

# Project Base: Install the base stack for a specific development
# platform.
# Available values: 'drupal'

project_base = ""

# Git SSH: SSH endpoint for git repository.  This will automatically
# check the project out to the document root for this project.
# NOTE: Repository must be configured to use SSH and not HTTP(S)

git_ssh = ""

##################################################
##################################################
###### DO NOT EDIT ANYTHING BELOW THIS LINE ######
##################################################
##################################################

settings = {
  "project_base" => "#{project_base}",
  "git_ssh" => "#{git_ssh}",
  "client_key" => "#{client_key}"
}

Vagrant.configure("2") do |config|

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
  end

  config.vm.box = "ubuntu/trusty64"
  # config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  # config.vm.box_url = "https://github.com/kraksoft/vagrant-box-ubuntu/releases/download/14.04/ubuntu-14.04-amd64.box"
  config.vm.hostname = "#{client_key}.local"
  config.vm.network :private_network, :auto_network => true

  config.ssh.forward_agent = true

  config.vm.synced_folder "./www/", "/var/www/", :id => "doc_root", :type => "nfs"

  config.vm.provision :puppet do |puppet|
    puppet.facter = settings
    puppet.module_path = "modules"
    puppet.options = "--pluginsync"
  end

end
