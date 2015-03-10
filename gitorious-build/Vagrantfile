# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.4"

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network :forwarded_port, guest: 80, host: 7080
  config.vm.network :forwarded_port, guest: 22, host: 7022
  config.vm.network :forwarded_port, guest: 9418, host: 9418

  config.vm.provider :virtualbox do |v, override|
    v.memory = 2048
    v.cpus = 2
    v.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  config.vm.provision "docker"
end
