# Vagrantfile

ENV["VAGRANT_DEFAULT_PROVIDER"] = "libvirt"

Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.nfs.verify_installed = false
  config.ssh.password = "infranetic"
  config.ssh.username = "infranetic"
  config.ssh.verify_host_key = false
  config.vm.box = "infranetic"
  config.vm.provider "libvirt" do |v|
    v.cpus = 2
    v.loader = "/usr/share/edk2/ovmf/OVMF_CODE.fd"
    v.memory = 2048
  end
  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.define :local_server_1 do |c|
    c.vm.hostname = "local-server-1"
  end

  config.vm.define :local_server_2 do |c|
    c.vm.hostname = "local-server-2"
  end

  config.vm.define :local_server_3 do |c|
    c.vm.hostname = "local-server-3"
  end
end
