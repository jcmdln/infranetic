# SPDX-License-Identifier: ISC

ENV["VAGRANT_DEFAULT_PROVIDER"] = "libvirt"
ENV["VAGRANT_NO_PARALLEL"] = "yes"

Vagrant.configure("2") do |config|
  config.vagrant.plugins = ["vagrant-hostmanager", "vagrant-libvirt"]

  config.vm.box = "infranetic/fedora-34"
  config.ssh.password = "infranetic"
  config.ssh.username = "infranetic"
  config.ssh.verify_host_key = false

  config.nfs.verify_installed = false
  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true

  (1..3).each do |i|
    config.vm.define "infranetic-mgmt#{i}" do |c|
      c.vm.hostname = "infranetic-mgmt#{i}"
      c.vm.provider "libvirt" do |v|
        v.cpus = 2
        v.loader = "/usr/share/edk2/ovmf/OVMF_CODE.fd"
        v.memory = 2048
      end
    end
  end

end
