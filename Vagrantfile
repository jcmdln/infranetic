# Vagrantfile

ENV["VAGRANT_DEFAULT_PROVIDER"] = "libvirt"

Vagrant.configure("2") do |config|
  config.vm.define :infranetic_core_1 do |c|
    c.nfs.verify_installed = false

    c.ssh.password = "infranetic"
    c.ssh.username = "infranetic"
    c.ssh.verify_host_key = false

    c.vm.box = "infranetic/core"
    c.vm.synced_folder '.', '/vagrant', disabled: true

    c.vm.provider "libvirt" do |v|
      v.cpus = 2
      v.loader = "/usr/share/edk2/ovmf/OVMF_CODE.fd"
      v.memory = 2048
    end
  end
end