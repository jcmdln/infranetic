# SPDX-License-Identifier: ISC

ENV["VAGRANT_NO_PARALLEL"] = "yes"

Vagrant.configure("2") do |config|
  config.vagrant.plugins = ["vagrant-hostmanager", "vagrant-libvirt"]

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true

  config.nfs.verify_installed = false
  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.provider "libvirt" do |v|
    v.cpus = 2
    v.memory = 4096
  end

  config.vm.provider "virtualbox" do |v|
    v.cpus = 2
    v.memory = 4096
  end

  config.vm.define "centos" do |c|
    c.vm.box = "generic/centos9s"
    c.vm.box_version = "4.1.0"
  end

  config.vm.define "debian" do |c|
    c.vm.box = "generic/debian11"
    c.vm.box_version = "4.1.0"
  end

  config.vm.define "ubuntu" do |c|
    c.vm.box = "generic/ubuntu2204"
    c.vm.box_version = "4.1.0"
  end
end
