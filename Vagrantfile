# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

# global variables definition
seed_box="precise64"
host_ip="192.168.56.110"
hostname="openstack-dev1"

script_name="install-devstack"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    # setup seed vm box 
    config.vm.box = "#{seed_box}"

    #setup networking
    config.vm.network :private_network, ip: "#{host_ip}"
    config.vm.network :public_network

    # syncup folder setting
    config.vm.synced_folder "data", "/vagrant_data"

    # using shell to install openstack
    config.vm.provision :shell, :path => "scripts/#{script_name}.sh"

    # if using VirtualBox
    config.vm.define "#{hostname}" do |box|

      box.vm.hostname = "#{hostname}"

      # using shell to install openstack
      #config.vm.provision :shell, :path => "scripts/#{script_name}.sh"

      box.vm.provider :virtualbox do |vbox|
        # Defaults
        #setup networking
        #vbox.vm.network :private_network, ip: "#{host_ip}"

        #vbox.vm.box = "#{seed_box}"
        vbox.customize ["modifyvm", :id, "--memory", 512]
        vbox.customize ["modifyvm", :id, "--cpus", 1]

        # syncup folder setting
        #vbox.vm.synced_folder "data", "/vagrant_data"
        # using shell to install openstack
        #vbox.vm.provision :shell, :path => "scripts/#{script_name}.sh"
      end
    end
end
