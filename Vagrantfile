# -*- mode: ruby -*-
# vi: set ft=ruby tabstop=8 expandtab shiftwidth=2 softtabstop=2 :

require 'yaml'
config_file=File.expand_path(File.join(File.dirname(__FILE__), 'vagrant_variables.yml'))
settings=YAML.load_file(config_file)


# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vagrant.plugins = ["vagrant-disksize", "vagrant-vbguest"]

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  #config.vm.box = "ubuntu/focal64"
  config.vm.box = "rockylinux/8"
  config.vm.box_version = "<= 4.0.0"  # vbguest broken in rockylinux/8 version 5.0.0
  config.vm.define settings['hostname']
  config.vm.hostname = settings['hostname']
  # thin provisioning, won't take 50G upfront
  config.disksize.size = settings.fetch('disksize', '50GB')

  # bug https://github.com/hashicorp/vagrant/issues/3341 still happening as of
  # 2019-10-31 with VirtualBox 6.0.12
  config.vbguest.auto_update = false

  # bridge networking to get real DNS name on local network
  if settings.has_key?('hostip')
    if settings.has_key?('network_bridge')
      config.vm.network "public_network", ip: settings['hostip'], bridge: settings['network_bridge']
    else
      config.vm.network "public_network", ip: settings['hostip']
    end
  else
    if settings.has_key?('network_bridge')
      config.vm.network "public_network", bridge: settings['network_bridge']
    else
      config.vm.network "public_network"
    end
  end

  config.vm.provider "virtualbox" do |v|
      v.memory = settings.fetch('memory', 4096)
      v.cpus = settings.fetch('cpus', 2)
  end

  #
  # Run Ansible from the Vagrant Host
  #
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/site.yml"
    ansible.config_file = "ansible/ansible.cfg"
    ansible.limit = "empty"
    ansible.become = true  # needed for rockylinux/8 box
    ansible.groups = {
      "empty" => [settings['hostname']]
    }
    ansible.raw_arguments = ["--verbose", "--diff"]
    # ansible.raw_arguments = Shellwords.shellsplit(ENV['ANSIBLE_ARGS']) if ENV['ANSIBLE_ARGS']
    #
    # # CLI command.
    # ANSIBLE_ARGS='--extra-vars "some_var=value"' vagrant up
    #
    # This allows the playbook to work either way (with or without any
    # ANSIBLE_ARGS).
    #
    # https://gist.github.com/phantomwhale/9657134#gistcomment-2130145
  end

end
