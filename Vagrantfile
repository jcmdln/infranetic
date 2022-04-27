# SPDX-License-Identifier: ISC

ENV["VAGRANT_DEFAULT_PROVIDER"] = "libvirt"
ENV["VAGRANT_NO_PARALLEL"] = "yes"

Vagrant.configure("2") do |config|
  config.vagrant.plugins = ["vagrant-hostmanager", "vagrant-libvirt"]

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true

  config.nfs.verify_installed = false
  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.box = "jcmdln/fedora"
  config.vm.box_version = "35"
  config.vm.provider "libvirt" do |v|
    v.cpus = 2
    v.loader = "/usr/share/OVMF/OVMF_CODE.fd"
    v.memory = 2048
  end

  (1..3).each do |i|
    config.vm.define "mgmt#{i}"
  end
end
